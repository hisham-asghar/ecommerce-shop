import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import Stripe from 'stripe'

import { findOrCreateStripeCustomer, createPaymentIntent } from './stripe'

export function userOrdersPath(uid: string): string { return `users/${uid}/orders` }
export function userOrderPath(uid: string, orderId: string): string { return `users/${uid}/orders/${orderId}` }
export function cartPath(uid: string): string { return `users/${uid}/private/cart` }
export function productPath(productId: string): string { return `products/${productId}` }
export function customerPath(customerId: string): string { return `customers/${customerId}` }

export async function createOrderPaymentIntent(data: any, context: functions.https.CallableContext) {
    const uid = context.auth?.uid
    try {
        if (uid === null || uid === undefined) {
            throw new functions.https.HttpsError(
                'unauthenticated',
                'The user is not authenticated.'
            )
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
        throw error
    }
}

async function checkItemsInStock(uid: string, firestore: FirebaseFirestore.Firestore, transaction: FirebaseFirestore.Transaction) {
    // First check that all products have sufficient stock
    const cartDocRef = firestore.doc(cartPath(uid))
    const cartDoc = await transaction.get(cartDocRef)
    const { items } = cartDoc.data() ?? []
    for (const item of items) {
        // extract the items data
        const { productId, quantity } = item
        // find a matching product
        const product = await transaction.get(firestore.doc(productPath(productId)))
        if (product !== undefined) {
            const { availableQuantity, title } = product.data()!
            if (availableQuantity == 0) {
            }
            if (availableQuantity < quantity) {
                console.log(`"${title}" is out of stock (requested ${quantity} items but only ${availableQuantity} are available)'`)
                throw new functions.https.HttpsError(
                    'aborted',
                    `"${title}" is out of stock. Please remove it from your cart or try again later.`
                )
            }
        } else {
            console.log(`Attempted to purchase product with id: "${productId}", which is no longer available.`)
            throw new functions.https.HttpsError(
                'aborted',
                `Attempted to purchase product with id: "${productId}", which is no longer available.`
            )
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

            const cartDocRef = firestore.doc(cartPath(uid))
            const cartDoc = await transaction.get(cartDocRef)
            const { items } = cartDoc.data() ?? []
                    
            // Calculate new available quantity for products
            var products = new Array()
            for (const item of items) {
                // extract the items data
                const { productId, quantity } = item
                // find a matching product
                const productRef = firestore.doc(productPath(productId))
                const product = await transaction.get(productRef)
                if (product !== undefined) {
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
            await transaction.delete(cartDocRef)

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
    const cartDocRef = firestore.doc(cartPath(uid))
    const cartDoc = await transaction.get(cartDocRef)
    const { items } = cartDoc.data() ?? []
    for (const item of items) {
        // extract the items data
        const { productId, quantity } = item
        // find a matching product
        const product = await transaction.get(firestore.doc(productPath(productId)))
        if (product !== undefined) {
            const { price } = product.data()!
            const itemPrice = price * quantity
            updatedPrice += itemPrice
        } else {
            console.warn(`Could not find product with id: ${productId}`)
            throw new functions.https.HttpsError(
                'aborted',
                `Could not find product with id: ${productId}`
            )
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