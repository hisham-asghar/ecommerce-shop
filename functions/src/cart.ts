import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

export async function updateCartTotal(context: functions.EventContext) {
    const uid = context.auth!.uid;
    const firestore = admin.firestore()
    var updatedPrice = 0;
    // iterate through all the cart items
    const collection = await firestore.collection(`users/${uid}/cartItems`).get();
    for (const doc of collection.docs) {
        // extract the items data
        const { productId, quantity } = doc.data()
        // find a matching product
        const product = await firestore.doc(`product/${productId}`).get();
        if (product !== undefined) {
            const { price } = product.data()!
            const itemPrice = price * quantity;
            updatedPrice += itemPrice;
        } else {
            // TODO: Throw some error (or fail silently?)
        }
    }
    await firestore.doc(`users/${uid}/public/cart`).set({
        'total': updatedPrice
    })
}