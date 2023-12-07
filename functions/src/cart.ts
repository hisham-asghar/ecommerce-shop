import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import Stripe from 'stripe'

import { findOrCreateStripeCustomer, createPaymentIntent } from './stripe'

export function userOrdersPath(uid: string): string { return `users/${uid}/orders` }
export function userOrderPath(uid: string, orderId: string): string { return `users/${uid}/orders/${orderId}` }
export function cartPath(uid: string): string { return `users/${uid}/private/cart` }
export function cartItemsPath(uid: string): string { return `users/${uid}/cartItems` }
export function productPath(productId: string): string { return `products/${productId}` }
export function customerPath(customerId: string): string { return `customers/${customerId}` }

export async function updateCartTotal(context: functions.EventContext) {
    // TODO: This should not be triggered when an order is fullfilled
    const uid = context.params.uid;
    const firestore = admin.firestore()
    const cartTotal = await calculateCartTotal(uid, firestore)
    console.log(`Updated cart total: ${cartTotal}`)
    return await firestore.doc(cartPath(uid)).set({
        'total': cartTotal
    }, { merge: true })
}

export async function createOrderPaymentIntent(data: any, context: functions.https.CallableContext) {
    const uid = context.auth?.uid
    try {
        if (uid === null || uid === undefined) {
            throw new functions.https.HttpsError('unauthenticated',
                'The user is not authenticated.')
        }
        const firestore = admin.firestore()
        // check if all items are in stock (throws in case of error)
        await checkItemsInStock(uid, firestore)
        // calculate total
        const cartTotal = await calculateCartTotal(uid, firestore)
        
        const customer = await findOrCreateStripeCustomer(uid)
        // map with paymentIntent, ephemeralKey, customer
        return createPaymentIntent(cartTotal, customer)
        
        // note: the rest of the process will complete via webhook

    } catch (error) {
        console.warn(`Could not place order for user: ${uid}`, error);
        throw error;
    }
}

async function checkItemsInStock(uid: string, firestore: FirebaseFirestore.Firestore) {
    // First check that all products have sufficient stock
    const cartItemsCollectionRef = firestore.collection(cartItemsPath(uid))
    const cartItemsCollection = await cartItemsCollectionRef.get()
    for (const doc of cartItemsCollection.docs) {
        // extract the items data
        const { productId, quantity } = doc.data()
        // find a matching product
        const product = await firestore.doc(productPath(productId)).get();
        if (product !== undefined) {
            const { availableQuantity } = product.data()!
            if (availableQuantity < quantity) {
                throw new functions.https.HttpsError('aborted',
                `Item ${productId} doesn't have enough stock`)
            }
        } else {
            throw new functions.https.HttpsError('aborted',
            `Could not find product with id: ${productId}`)
        }
    }
}

export async function fullfillOrder(pi: Stripe.PaymentIntent) {
    const customerId = pi.customer
    try {
        // TODO: Run all this as a transaction
        const firestore = admin.firestore()
        const customerDoc = await firestore.doc(customerPath(customerId as string)).get()
        const customerData = customerDoc.data()
        if (customerData == undefined) {
            console.error(`customer not found at ` + customerPath(customerId as string))
            return
        }
        const { uid } = customerData

        // TODO: this should match pi.amount / 100
        const cartTotal = await calculateCartTotal(uid, firestore)

        const cartItemsCollectionRef = firestore.collection(cartItemsPath(uid))
        const cartItemsCollection = await cartItemsCollectionRef.get()

        // Then, update product stock levels and empty the cart data
        var items = new Array()
        for (const doc of cartItemsCollection.docs) {
            // extract the items data
            const { productId, quantity } = doc.data()
            // find a matching product
            const productRef = firestore.doc(productPath(productId))
            const product = await productRef.get();
            if (product !== undefined) {
                const { availableQuantity } = product.data()!
                // TODO: available quantity check?
                // Update available quantity
                await productRef.update({
                    'availableQuantity': availableQuantity - quantity
                })
                // update items
                items.push({
                    'productId': productId,
                    'quantity': quantity,
                })
            }
            // Delete document from cart
            // TODO: Is it valid to delete inside this loop?
            // Will this trigger a cart total update?
            await doc.ref.delete()
        }

        // save order document data so it can be returned at the end
        const orderData = {
            'userId': uid,
            'total': cartTotal,
            'orderStatus': 'confirmed',
            'orderDate': new Date().toISOString(),
            'items': items,
            'payment': {
                'id': pi.id,
                'amount': pi.amount,
                'source': pi.source,
                'invoice': pi.invoice                
            }            
        }
        await firestore.collection(userOrdersPath(uid)).add(orderData)

        // finally, remove the cart document (a new one will be created when the user adds items again)
        await firestore.doc(cartPath(uid)).delete()

    } catch (error) {
        console.warn(`Could not fullfill order: ${customerId}`, error);
        throw error;
    }
}


async function calculateCartTotal(uid: string, firestore: FirebaseFirestore.Firestore) {
    var updatedPrice = 0;
    // iterate through all the cart items
    const collection = await firestore.collection(cartItemsPath(uid)).get()
    for (const doc of collection.docs) {
        // extract the items data
        const { productId, quantity } = doc.data()
        // find a matching product
        const product = await firestore.doc(productPath(productId)).get()
        if (product !== undefined) {
            const { price } = product.data()!
            const itemPrice = price * quantity
            updatedPrice += itemPrice
        } else {
            throw new functions.https.HttpsError('aborted',
            `Could not find product with id: ${productId}`)
        }
    }
    return updatedPrice
}