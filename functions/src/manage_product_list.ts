
import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

export async function manageProductList(request: functions.Request, response: functions.Response) {
    // TODO: Validate with some admin credentials (not all users should be able to do this)
    const firestore = admin.firestore()
    if (request.method === 'POST') {
        // https://stackoverflow.com/questions/44078037/how-to-get-firebase-project-name-or-id-from-cloud-function
        const projectId = process.env.GCLOUD_PROJECT || ""
        await generateProductList(projectId, firestore)
        response.sendStatus(200)
    }
    else if (request.method === 'DELETE'){
        await clearProductList(firestore)
        response.sendStatus(200)
    } else {
        response.status(400).send(`Only POST and DELETE requests are allowed. Received ${request.method}`)
    }
}

async function generateProductList(projectId: string, firestore: FirebaseFirestore.Firestore) {
    
    const productsData = [
        {
            id: '1',
            imageUrl: `https://firebasestorage.googleapis.com/v0/b/${projectId}.appspot.com/o/products%2Fbruschetta-plate.jpg?alt=media`,
            title: 'Bruschetta plate',
            description: 'Lorem ipsum',
            price: 15,
            availableQuantity: 10
        },
        {
            id: '2',
            imageUrl: `https://firebasestorage.googleapis.com/v0/b/${projectId}.appspot.com/o/products%2Fmozzarella-plate.jpg?alt=media`,
            title: 'Mozzarella plate',
            description: 'Lorem ipsum',
            price: 13,
            availableQuantity: 10
        },
        {
            id: '3',
            imageUrl: `https://firebasestorage.googleapis.com/v0/b/${projectId}.appspot.com/o/products%2Fpasta-plate.jpg?alt=media`,
            title: 'Pasta plate',
            description: 'Lorem ipsum',
            price: 17,
            availableQuantity: 10
        },
        {
            id: '4',
            imageUrl: `https://firebasestorage.googleapis.com/v0/b/${projectId}.appspot.com/o/products%2Fpiggy-blue.jpg?alt=media`,
            title: 'Piggy Bank Blue',
            description: 'Lorem ipsum',
            price: 12,
            availableQuantity: 10
        },
        {
            id: '5',
            imageUrl: `https://firebasestorage.googleapis.com/v0/b/${projectId}.appspot.com/o/products%2Fpiggy-green.jpg?alt=media`,
            title: 'Piggy Bank Green',
            description: 'Lorem ipsum',
            price: 12,
            availableQuantity: 10
        },
        {
            id: '6',
            imageUrl: `https://firebasestorage.googleapis.com/v0/b/${projectId}.appspot.com/o/products%2Fpiggy-pink.jpg?alt=media`,
            title: 'Piggy Bank Pink',
            description: 'Lorem ipsum',
            price: 12,
            availableQuantity: 10
        },
        {
            id: '7',
            imageUrl: `https://firebasestorage.googleapis.com/v0/b/${projectId}.appspot.com/o/products%2Fpizza-plate.jpg?alt=media`,
            title: 'Pizza plate',
            description: 'Lorem ipsum',
            price: 18,
            availableQuantity: 10
        },
        {
            id: '8',
            imageUrl: `https://firebasestorage.googleapis.com/v0/b/${projectId}.appspot.com/o/products%2Fplate-and-bowl.jpg?alt=media`,
            title: 'Plate and Bowl',
            description: 'Lorem ipsum',
            price: 21,
            availableQuantity: 10
        },
        {
            id: '9',
            imageUrl: `https://firebasestorage.googleapis.com/v0/b/${projectId}.appspot.com/o/products%2Fsalt-pepper-lemon.jpg?alt=media`,
            title: 'Salt and pepper lemon',
            description: 'Lorem ipsum',
            price: 11,
            availableQuantity: 10
        },
        {
            id: '10',
            imageUrl: `https://firebasestorage.googleapis.com/v0/b/${projectId}.appspot.com/o/products%2Fsalt-pepper-olives.jpg?alt=media`,
            title: 'Salt and pepper olives',
            description: 'Lorem ipsum',
            price: 11,
            availableQuantity: 10
        },
        {
            id: '11',
            imageUrl: `https://firebasestorage.googleapis.com/v0/b/${projectId}.appspot.com/o/products%2Fsnacks-plate.jpg?alt=media`,
            title: 'Snacks plate',
            description: 'Lorem ipsum',
            price: 24,
            availableQuantity: 10
        }
    ]
    for (var product of productsData) {
        // insert new document for product with given ID
        await firestore.doc(`products/${product.id}`).set(product)
    }
}

async function clearProductList(firestore: FirebaseFirestore.Firestore) {
    const collectionRef = firestore.collection(`products`)
    const collection = await collectionRef.get()
    for (var doc of collection.docs) {
        firestore.doc(`products/${doc.id}`).delete()
    }
}