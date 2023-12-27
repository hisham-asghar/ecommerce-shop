import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import Stripe from 'stripe'

//const stripePublishableKey = functions.config().stripe?.public_key
const stripeSecretKey = functions.config().stripe?.secret_key
const stripeWebhookSecretKey = functions.config().stripe?.webhook_secret_key

import { fullfillOrder, setCustomerUid } from './cart'

// for testing purposes
// export async function getStripePublicKeyHttps(response: functions.Response<any>) {
//     if (stripePublishableKey === undefined) {
//         response.send(404)        
//     }
//     response.send(stripePublishableKey)    
// }

// export async function getStripePublicKeyCallable() {
//     if (stripePublishableKey === undefined) {
//         throw new functions.https.HttpsError('aborted', 'Public Key is not set')
//     }
//     return {
//         'publicKey': stripePublishableKey
//     }
// }


export async function findOrCreateStripeCustomer(uid: string) {
    const user = await admin.auth().getUser(uid)
    if (user.email === null) {
        throw new functions.https.HttpsError('unauthenticated',
            'User does not have an email')
    }

    const stripe = getStripe()

    const customers = await stripe.customers.list({email: user.email})
    if (customers.data.length > 0) {
        const customer = customers.data[0]
        // TODO: does this need to be an override?
        await setCustomerUid(customer.id, uid)
        return customer
    } else {
        // https://stripe.com/docs/api/customers/create
        const customer = await stripe.customers.create({ email: user.email })
        await setCustomerUid(customer.id, uid)
        return customer
    }
}

export async function createPaymentIntent(amount: number, customer: Stripe.Customer) {
    const stripe = getStripe()
    const ephemeralKey = await stripe.ephemeralKeys.create(
        { customer: customer.id },
        { apiVersion: '2020-08-27' }
      )
    console.log(`amount: ${amount}, customerId: ${customer.id}`)
    const paymentIntent = await stripe.paymentIntents.create({
        amount: amount * 100,
        currency: 'usd',
        customer: customer.id,
    })
    return {
        paymentIntent: paymentIntent.client_secret,
        ephemeralKey: ephemeralKey.secret,
        customer: customer.id,
    }
}

// Expose a endpoint as a webhook handler for asynchronous events.
// Configure your webhook in the stripe developer dashboard:
// https://dashboard.stripe.com/test/webhooks
export async function stripeWebhook(req: functions.https.Request, res: functions.Response<any>) {

    if (stripeWebhookSecretKey === undefined) {
        console.error(`⚠️  Stripe webhook secret is not set`)
        res.sendStatus(400)
    }
    // Retrieve the event by verifying the signature using the raw body and secret.
    let event: Stripe.Event;
    const stripe = getStripe()
    // console.log('webhook body:', req.rawBody)
    // console.log('webhook headers:', req.headers['stripe-signature'])
    // console.log('webhook secret:', stripeWebhookSecretKey)
    try {
        event = stripe.webhooks.constructEvent(
          // Note: to perform the verfication correctlly, we *must* use the rawBody
          // See: https://medium.com/@GaryHarrower/working-with-stripe-webhooks-firebase-cloud-functions-5366c206c6c
          req.rawBody,
          req.headers['stripe-signature'] || [],
          stripeWebhookSecretKey
        )
    } catch (err) {
        console.log(`⚠️  Webhook signature verification failed.`)
        res.sendStatus(400)
        return
    }

    // Extract the data from the event.
    const data: Stripe.Event.Data = event.data
    const eventType: string = event.type

    if (eventType === 'payment_intent.succeeded') {
        // Cast the event into a PaymentIntent to make use of the types.
        const pi: Stripe.PaymentIntent = data.object as Stripe.PaymentIntent
  
        // Funds have been captured
        // Fulfill any orders, e-mail receipts, etc
        // To cancel the payment after capture you will need to issue a Refund (https://stripe.com/docs/api/refunds).
        console.log(`🔔  Webhook received: ${pi.object} ${pi.status}!`)
        console.log(`💰 Payment captured! Amount: ${pi.amount}, customerId: ${pi.customer}`)
        
        // Order fullfillment
        try {
            await fullfillOrder(pi)
            console.log('🔔 Order fullfillment succeeded.')
        } catch (e) {
            console.warn(`❌ Order fullfillment failed: ${e}`)
        }
    }
    if (eventType === 'payment_intent.payment_failed') {
        // Cast the event into a PaymentIntent to make use of the types.
        const pi: Stripe.PaymentIntent = data.object as Stripe.PaymentIntent
        console.log(`🔔  Webhook received: ${pi.object} ${pi.status}!`)
        console.warn('❌ Payment failed.')
    }
  
    if (eventType === 'setup_intent.setup_failed') {
        console.log(`🔔  A SetupIntent has failed the to setup a PaymentMethod.`)
    }
  
    if (eventType === 'setup_intent.succeeded') {
        console.log(
          `🔔  A SetupIntent has successfully setup a PaymentMethod for future use.`
        )
    }
  
    if (eventType === 'setup_intent.created') {
        const setupIntent: Stripe.SetupIntent = data.object as Stripe.SetupIntent
        console.log(`🔔  A new SetupIntent is created. ${setupIntent.id}`)
    }
  
    res.sendStatus(200);
}
  
function getStripe() {
    if (stripeSecretKey === undefined) {
        throw new functions.https.HttpsError('aborted', 'Stripe Secret Key is not set')
    }

    return new Stripe(stripeSecretKey as string, {
      apiVersion: '2020-08-27',
      typescript: true,
    })
}