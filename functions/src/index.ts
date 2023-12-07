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
import { updateCartTotal, createOrderPaymentIntent } from './cart'

exports.updateCartTotal = functions.region(region).firestore
    .document(`users/{uid}/cartItems/{itemId}`).onWrite((_, context) => {
      return updateCartTotal(context);
    })

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
