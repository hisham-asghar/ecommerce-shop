
import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

export async function generateProductList(response: functions.Response) {
    const firestore = admin.firestore()
    const productsData = [
        {
            id: '1',
            //imageUrl: 'http://proshopapp.herokuapp.com/images/playstation.jpg',
            imageUrl: 'https://firebasestorage.googleapis.com/v0/b/my-shop-ecommerce-dev.appspot.com/o/products%2Fplaystation.jpg?alt=media&token=2008edd7-1eb9-4012-8d4e-7da4726e7e32',
            title: 'Sony Playstation 4 Pro White Version',
            description: 'Lorem impsum',
            price: 399,
            availableQuantity: 5
        },
        {
            id: '2',
            //imageUrl: 'http://proshopapp.herokuapp.com/images/alexa.jpg',
            imageUrl: 'https://firebasestorage.googleapis.com/v0/b/my-shop-ecommerce-dev.appspot.com/o/products%2Falexa.jpg?alt=media&token=9de7aa2e-17e9-4f3f-8dd8-dc2b2d18975c',
            title: 'Amazon Echo Dot 3rd Generation',
            description: 'Lorem impsum',
            price: 29,
            availableQuantity: 5
        },
        {
            id: '3',
            //imageUrl: 'http://proshopapp.herokuapp.com/images/camera.jpg',
            imageUrl: 'https://firebasestorage.googleapis.com/v0/b/my-shop-ecommerce-dev.appspot.com/o/products%2Fcamera.jpg?alt=media&token=f7ce462c-8a5b-4589-b6b5-d90fbd60aba0',
            title: 'Cannon EOS 80D DSLR Camera',
            description: 'Lorem impsum',
            price: 929,
            availableQuantity: 5
        },
        {
            id: '4',
            //imageUrl: 'http://proshopapp.herokuapp.com/images/phone.jpg',
            imageUrl: 'https://firebasestorage.googleapis.com/v0/b/my-shop-ecommerce-dev.appspot.com/o/products%2Fphone.jpg?alt=media&token=5efa7146-1f90-401d-8879-a9467b51f748',
            title: 'iPhone 11 Pro 256GB Memory',
            description: 'Lorem impsum',
            price: 599,
            availableQuantity: 5
        }
    ]
    for (var product of productsData) {
        // insert new document for product with given ID
        await firestore.doc(`products/${product.id}`).set(product)
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