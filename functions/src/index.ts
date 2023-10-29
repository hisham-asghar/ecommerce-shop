import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

admin.initializeApp();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

import { updateCartTotal } from './cart';

exports.cartItemUpdated = functions.region('europe-west2').firestore
    .document('users/{uid}/cartItems/{itemId}').onUpdate((change, context) => {
      updateCartTotal(context);
    });

exports.cartItemDeleted = functions.region('europe-west2').firestore
    .document('users/{uid}/cartItems/{itemId}').onDelete((change, context) => {
      updateCartTotal(context);
    });
