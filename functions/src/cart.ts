import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

export async function updateCartTotal(context: functions.EventContext) {
    const uid = context.params.uid;
    const firestore = admin.firestore()
    const cartTotal = await calculateCartTotal(uid, firestore)
    console.log(`Updated cart total: ${cartTotal}`)
    return await firestore.doc(`users/${uid}/private/cart`).set({
        'total': cartTotal
    })
}

export async function placeOrder(data: any, context: functions.https.CallableContext) {
    const uid = context.auth?.uid
    try {
        if (uid === null || uid === undefined) {
            throw new functions.https.HttpsError('unauthenticated',
                'The user is not authenticated.')
        }
        const firestore = admin.firestore()

        // TODO: Run all this as a transaction
        // First check that all products have sufficient stock
        var items = new Array()
        const cartItemsCollectionRef = firestore.collection(`users/${uid}/cartItems`)
        const cartItemsCollection = await cartItemsCollectionRef.get()
        for (const doc of cartItemsCollection.docs) {
            // extract the items data
            const { productId, quantity } = doc.data()
            // find a matching product
            const product = await firestore.doc(`products/${productId}`).get();
            if (product !== undefined) {
                const { availableQuantity } = product.data()!
                if (availableQuantity < quantity) {
                    throw new functions.https.HttpsError('aborted',
                    `Item ${productId} doesn't have enough stock`)
                }
                // TODO: should this include product data? Probably yes
                items.push({
                    'productId': productId,
                    'quantity': quantity,
                })
            } else {
                throw new functions.https.HttpsError('aborted',
                `Could not find product with id: ${productId}`)
            }
        }
        // Then, place order
        // TODO: Stripe place order
        // Then, write order data
        const cartTotal = await calculateCartTotal(uid, firestore)
        const userOrdersCollectionRef = firestore.collection(`users/${uid}/orders`)
        // save order document data so it can be returned at the end
        const orderData = {
            'userId': uid,
            'total': cartTotal,
            'orderStatus': 'confirmed',
            'orderDate': new Date().toISOString(),
            'items': items
            // TODO: other order fields
        }
        const orderRef = await userOrdersCollectionRef.add(orderData)        
        // Then, update product stock levels and empty the cart data
        for (const doc of cartItemsCollection.docs) {
            // extract the items data
            const { productId, quantity } = doc.data()
            // find a matching product
            const product = await firestore.doc(`products/${productId}`).get();
            if (product !== undefined) {
                const { availableQuantity } = product.data()!
                // Update available quantity
                await firestore.doc(`products/${productId}`).update({
                    'availableQuantity': availableQuantity - quantity
                })
            }
            // Delete document from cart
            // TODO: Is it valid to delete inside this loop?
            // Will this trigger a cart total update?
            await doc.ref.delete()
        }
        // finally, reset the price to 0
        await firestore.doc(`users/${uid}/public/cart`).set({
            'total': 0
        })
        // return order id and data
        return {
            'id': orderRef.id,
            'data' : orderData,
        }

    } catch (error) {
        console.warn(`Could not place order for user: ${uid}`, error);
        throw error;
    }
}


async function calculateCartTotal(uid: String, firestore: FirebaseFirestore.Firestore) {
    var updatedPrice = 0;
    // iterate through all the cart items
    const collection = await firestore.collection(`users/${uid}/cartItems`).get()
    for (const doc of collection.docs) {
        // extract the items data
        const { productId, quantity } = doc.data()
        // find a matching product
        const product = await firestore.doc(`products/${productId}`).get()
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