import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

admin.initializeApp();

const region = 'europe-west2'

import { updateCartTotal } from './cart'

exports.cartItemUpdated = functions.region(region).firestore
    .document('users/{uid}/cartItems/{itemId}').onUpdate((change, context) => {
      updateCartTotal(context);
    });

exports.cartItemDeleted = functions.region(region).firestore
    .document('users/{uid}/cartItems/{itemId}').onDelete((change, context) => {
      updateCartTotal(context);
    });

// products management
import { generateProductList, clearProductList } from './generate_product_list'

exports.generateProductList = functions.region(region).https.onRequest((request, response) => {
  generateProductList(response)
})

exports.clearProductList = functions.region(region).https.onRequest((request, response) => {
  clearProductList(response)
})


