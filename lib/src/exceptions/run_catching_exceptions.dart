import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/app_exception.dart';

Future<Result<AppException, T>> runCatchingExceptions<T>(
    Future<T> Function() task) async {
  try {
    final result = await task();
    return Success(result);
  } on FirebaseAuthException catch (e, st) {
    switch (e.code) {
      // sign in and create user errors
      case 'invalid-email':
        return Error(AppException.invalidEmail(e.message));
      case 'wrong-password':
        return Error(AppException.wrongPassword(e.message));
      case 'user-not-found':
        return Error(AppException.userNotFound(e.message));
      case 'user-disabled':
        return Error(AppException.userDisabled(e.message));
      case 'email-already-in-use':
        return Error(AppException.emailAlreadyInUse(e.message));
      case 'weak-password':
        return Error(AppException.weakPassword(e.message));
      case 'operation-not-allowed':
        return Error(AppException.operationNotAllowed(e.message));
      case 'too-many-requests':
        return Error(AppException.tooManyAuthRequests(e.message));
      default:
        return Error(AppException.unknown(e, st));
    }
  } on FirebaseFunctionsException catch (e) {
    return Error(AppException.functions(e.message ?? e.toString()));
  } on FirebaseException catch (e, st) {
    switch (e.code) {
      case 'permission-denied':
        return Error(AppException.permissionDenied(e.message ?? e.toString()));
      default:
        return Error(AppException.unknown(e, st));
    }
  } on StripeException catch (e, st) {
    if (e.error.code == FailureCode.Failed) {
      return Error(AppException.paymentFailed(e.error.localizedMessage));
    } else if (e.error.code == FailureCode.Canceled) {
      return Error(AppException.paymentCanceled(e.error.localizedMessage));
    } else {
      return Error(AppException.unknown(e, st));
    }
  } on AppException catch (e) {
    // * if an [AppException] is thrown, just return it as an error
    return Error(e);
  } catch (e, st) {
    return Error(AppException.unknown(e, st));
  }
}
