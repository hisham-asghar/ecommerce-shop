import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

admin.initializeApp();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

import { updateCartTotal } from './cart';

exports.cartItemUpdated = functions.firestore
    .document('users/{uid}/public/cart').onUpdate((change, context) => {
      updateCartTotal(context);
    });

exports.cartItemDeleted = functions.firestore
    .document('users/{uid}/public/cart').onDelete((change, context) => {
      updateCartTotal(context);
    });
