import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

admin.initializeApp();

const region = 'us-central1'

import { updateCartTotal, placeOrder } from './cart'

exports.updateCartTotal = functions.region(region).firestore
    .document(`users/{uid}/cartItems/{itemId}`).onWrite((_, context) => {
      return updateCartTotal(context);
    })

exports.placeOrder = functions.region(region).https.onCall(placeOrder)

// products management
import { generateProductList, clearProductList } from './generate_product_list'

exports.generateProductList = functions.region(region).https.onRequest((_, response) => {
  generateProductList(response)
})

exports.clearProductList = functions.region(region).https.onRequest((_, response) => {
  clearProductList(response)
})

// orders management
import { copyOrderToAdmin, copyOrderToUser } from './orders'

exports.copyOrderToAdmin = functions.region(region).firestore
  .document(`users/{uid}/orders/{orderId}`).onCreate((snapshot, context) => {
    return copyOrderToAdmin(snapshot);
  })

exports.copyOrderToUser = functions.region(region).firestore
  .document(`orders/{orderId}`).onUpdate((change, context) => {
    return copyOrderToUser(change.after);
  })
