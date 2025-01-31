import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

admin.initializeApp();

const region = 'us-central1'

// Admin
import { promoteToAdminIfWhitelisted } from './admin'

exports.promoteToAdminIfWhitelisted = functions.region(region).auth.user().onCreate((user, context) => {
  return promoteToAdminIfWhitelisted(user, context)
})

// Migrations
// * Commented out as it should not be enabled in production
// import { manageShoppingCart } from './migrations';
// exports.manageShoppingCart = functions.region(region).https.onRequest(manageShoppingCart);

// Cart
import { createOrderPaymentIntent } from './cart'

exports.createOrderPaymentIntent = functions.region(region).https.onCall(createOrderPaymentIntent)

// Reviews

import { updateRating } from './reviews'

exports.updateProductRating = functions.region(region).firestore
  .document(`products/{id}/reviews/{uid}`)
  .onWrite((change, _) => updateRating(change))


// Stripe 

import { stripeWebhook } from './stripe'

exports.stripeWebhook = functions.region(region).https.onRequest((request, response) => {
  stripeWebhook(request, response)
})

// exports.getStripePublicKey = functions.region(region).https.onRequest((_, response) => {
//     getStripePublicKeyHttps(response)
// })

// exports.getStripePublicKeyCallable = functions.region(region).https.onCall((data: any, context: functions.https.CallableContext) => {
//     return getStripePublicKeyCallable()
// })


// products management
import { manageProductList } from './manage_product_list'

exports.manageProductList = functions.region(region).https.onRequest((request, response) => {
  manageProductList(request, response)
})
