import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

export async function manageShoppingCart(request: functions.Request, response: functions.Response) {
    // TODO: Validate with some admin credentials (not all users should be able to do this)
    const firestore = admin.firestore()
    if (request.method === 'DELETE') {
        await clearShoppingCart(firestore)
        response.sendStatus(200)
    } else {
        response.status(400).send(`Only DELETE requests are allowed. Received ${request.method}`)
    }
}

async function clearShoppingCart(firestore: FirebaseFirestore.Firestore) {
    const usersRef = firestore.collection(`users`)
    const docRefs = await usersRef.listDocuments()
    for (const docRef of docRefs) {
        const privateCartRef = firestore.doc(`users/${docRef.id}/private/cart`)
        console.warn(`Deleting ${privateCartRef.path}`)
        privateCartRef.delete()
    }
}
