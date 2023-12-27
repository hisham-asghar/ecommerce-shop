
import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

export async function generateProductList(response: functions.Response) {
    const firestore = admin.firestore()
    const productsData = [
        {
            id: '1',
            imageUrl: 'https://firebasestorage.googleapis.com/v0/b/my-shop-ecommerce-dev.appspot.com/o/products%2Fbruschetta-plate.jpg?alt=media&token=cb1d8b48-a14a-415d-96a7-51bd90015b14',
            title: 'Bruschetta plate',
            description: 'Lorem ipsum',
            price: 15,
            availableQuantity: 5
        },
        {
            id: '2',
            imageUrl: 'https://firebasestorage.googleapis.com/v0/b/my-shop-ecommerce-dev.appspot.com/o/products%2Fmozzarella-plate.jpg?alt=media&token=8fe12a50-985c-42d2-bf7e-6e0caeff5fa9',
            title: 'Amazon Echo Dot 3rd Generation',
            description: 'Lorem ipsum',
            price: 13,
            availableQuantity: 5
        },
        {
            id: '3',
            imageUrl: 'https://firebasestorage.googleapis.com/v0/b/my-shop-ecommerce-dev.appspot.com/o/products%2Fpasta-plate.jpg?alt=media&token=747d3f81-e733-4eda-805f-cc066ef2db34',
            title: 'Cannon EOS 80D DSLR Camera',
            description: 'Lorem ipsum',
            price: 17,
            availableQuantity: 5
        },
        {
            id: '4',
            imageUrl: 'https://firebasestorage.googleapis.com/v0/b/my-shop-ecommerce-dev.appspot.com/o/products%2Fpiggy-blue.jpg?alt=media&token=cea92e0d-7cf7-472b-87e7-8ed7a5924a97',
            title: 'iPhone 11 Pro 256GB Memory',
            description: 'Lorem ipsum',
            price: 12,
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