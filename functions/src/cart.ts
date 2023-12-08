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
    const firestore = admin.firestore()
    firestore.runTransaction(async (transaction) => {
        const uid = context.params.uid;
        const cartTotal = await calculateCartTotal(uid, firestore, transaction)
        console.log(`Updated cart total: ${cartTotal}`)
        return transaction.set(firestore.doc(cartPath(uid)), {
            'total': cartTotal
        }, { merge: true })
    
    })
}

export async function createOrderPaymentIntent(data: any, context: functions.https.CallableContext) {
    const uid = context.auth?.uid
    try {
        if (uid === null || uid === undefined) {
            throw new functions.https.HttpsError('unauthenticated',
                'The user is not authenticated.')
        }
        const firestore = admin.firestore()
        const cartTotal = await firestore.runTransaction(async (transaction) => {
            // check if all items are in stock (throws in case of error)
            await checkItemsInStock(uid, firestore, transaction)
            // calculate total
            return calculateCartTotal(uid, firestore, transaction)
        })
        const customer = await findOrCreateStripeCustomer(uid)
        // map with paymentIntent, ephemeralKey, customer
        return createPaymentIntent(cartTotal, customer)
    
        // note: the rest of the process will complete via webhook

    } catch (error) {
        console.warn(`Could not place order for user: ${uid}`, error);
        throw error;
    }
}

async function checkItemsInStock(uid: string, firestore: FirebaseFirestore.Firestore, transaction: FirebaseFirestore.Transaction) {
    // First check that all products have sufficient stock
    const cartItemsCollectionRef = firestore.collection(cartItemsPath(uid))
    const cartItemsCollection = await transaction.get(cartItemsCollectionRef)
    for (const doc of cartItemsCollection.docs) {
        // extract the items data
        const { productId, quantity } = doc.data()
        // find a matching product
        const product = await transaction.get(firestore.doc(productPath(productId)))
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
    const firestore = admin.firestore()
    await firestore.runTransaction(async (transaction) => {
        try {
            // ALL READS
            const customerRef = firestore.doc(customerPath(customerId as string))
            const customerDoc = await transaction.get(customerRef)
            const customerData = customerDoc.data()
            if (customerData == undefined) {
                console.error(`customer not found at ` + customerPath(customerId as string))
                return
            }
            const { uid } = customerData

            // this should match pi.amount / 100
            const cartTotal = await calculateCartTotal(uid, firestore, transaction)

            const cartItemsCollectionRef = firestore.collection(cartItemsPath(uid))
            const cartItemsCollection = await transaction.get(cartItemsCollectionRef)
            
            // Get all items and list all products
            var items = new Array()
            var products = new Array()
            for (const doc of cartItemsCollection.docs) {
                // extract the items data
                const { productId, quantity } = doc.data()
                // find a matching product
                const productRef = firestore.doc(productPath(productId))
                const product = await transaction.get(productRef)
                if (product !== undefined) {
                    items.push({ productId, quantity })
                    const { availableQuantity } = product.data()!
                    products.push({ productRef, 'availableQuantity': availableQuantity - quantity })
                }
            }
            // ALL WRITES
            // Update product quantities. We need to do this in a separate loop because
            // Firestore transactions require all reads to be executed before all writes.
            for (const product of products) {
                const { productRef, availableQuantity } = product
                // Update available quantity
                await transaction.update(productRef, {
                    'availableQuantity': availableQuantity
                })
            }
            // Delete all cart items
            for (const doc of cartItemsCollection.docs) {
                await transaction.delete(doc.ref)
            }
            // Delete cart (a new one will be created when the user adds items again)
            await transaction.delete(firestore.doc(cartPath(uid)))

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
            const newDocRef = firestore.collection(userOrdersPath(uid)).doc()
            await transaction.set(newDocRef, orderData)

        } catch (error) {
            console.warn(`Could not fullfill order: ${customerId}`, error);
            throw error;
        }
    })
}


async function calculateCartTotal(uid: string, firestore: FirebaseFirestore.Firestore, transaction: FirebaseFirestore.Transaction) {
    var updatedPrice = 0;
    // iterate through all the cart items
    const collection = await transaction.get(firestore.collection(cartItemsPath(uid)))
    for (const doc of collection.docs) {
        // extract the items data
        const { productId, quantity } = doc.data()
        // find a matching product
        const product = await transaction.get(firestore.doc(productPath(productId)))
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

export async function setCustomerUid(customerId: string, uid: string) {

    const firestore = admin.firestore()
    await firestore.doc(customerPath(customerId)).set({
        uid: uid
    })
}