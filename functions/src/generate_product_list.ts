
import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

export async function generateProductList(response: functions.Response) {
    const firestore = admin.firestore()
    const collectionRef = firestore.collection(`products`)
    const productsData = [
        {
            imageUrl: 'http://proshopapp.herokuapp.com/images/playstation.jpg',
            title: 'Sony Playstation 4 Pro White Version',
            description: 'Lorem impsum',
            price: 399,
            availableQuantity: 5
        },
        {
            imageUrl: 'http://proshopapp.herokuapp.com/images/alexa.jpg',
            title: 'Amazon Echo Dot 3rd Generation',
            description: 'Lorem impsum',
            price: 29,
            availableQuantity: 5
        },
        {
            imageUrl: 'http://proshopapp.herokuapp.com/images/camera.jpg',
            title: 'Cannon EOS 80D DSLR Camera',
            description: 'Lorem impsum',
            price: 929,
            availableQuantity: 5
        },
        {
            imageUrl: 'http://proshopapp.herokuapp.com/images/phone.jpg',
            title: 'iPhone 11 Pro 256GB Memory',
            description: 'Lorem impsum',
            price: 599,
            availableQuantity: 5
        }
    ]
    // TODO: How to generate IDs 
    for (var product of productsData) {
        // insert new document for product
        const doc = await collectionRef.add(product)
        // update its id
        await firestore.doc(`products/${doc.id}`).update({
            id: doc.id,
        })
    }
    response.sendStatus(200)
}

export async function clearProductList(response: functions.Response) {
    const firestore = admin.firestore()
    const collectionRef = firestore.collection(`products`)
    const collection = await collectionRef.get()
    for (var doc of collection.docs) {
        firestore.doc(`products/${doc.id}`).delete()
    }
    response.sendStatus(200)
}