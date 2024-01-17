import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

admin.initializeApp();

const region = 'us-central1'

// Admin
import { promoteToAdminIfWhitelisted } from './admin'

exports.promoteToAdminIfWhitelisted = functions.region(region).auth.user().onCreate((user, context) => {
  return promoteToAdminIfWhitelisted(user, context)
})

// Cart
import { createOrderPaymentIntent } from './cart'

exports.createOrderPaymentIntent = functions.region(region).https.onCall(createOrderPaymentIntent)

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
