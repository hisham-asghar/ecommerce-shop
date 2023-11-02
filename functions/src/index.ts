import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

admin.initializeApp();

const region = 'europe-west2'

import { updateCartTotal } from './cart'

exports.updateCartTotal = functions.region(region).firestore
    .document(`users/{uid}/cartItems/{itemId}`).onWrite((_, context) => {
      // TODO: Doesn't seem to be triggered
      updateCartTotal(context);
    });

// products management
import { generateProductList, clearProductList } from './generate_product_list'

exports.generateProductList = functions.region(region).https.onRequest((_, response) => {
  generateProductList(response)
})

exports.clearProductList = functions.region(region).https.onRequest((_, response) => {
  clearProductList(response)
})


