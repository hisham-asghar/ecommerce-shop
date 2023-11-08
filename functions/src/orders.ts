import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

export async function copyOrderToAdmin(snapshot: functions.firestore.QueryDocumentSnapshot) {
    const firestore = admin.firestore()
    // write data from `users/$uid/orders/$orderId` to `orders/orderId`
    await firestore.doc(`orders/${snapshot.id}`).set(snapshot.data())
}

export async function copyOrderToUser(snapshot: functions.firestore.QueryDocumentSnapshot) {
    const firestore = admin.firestore()
    // write data from `orders/orderId` to `users/$uid/orders/$orderId`
    const userId = snapshot.data()[`userId`]
    await firestore.doc(`users/${userId}/orders/${snapshot.id}`).set(snapshot.data())
}