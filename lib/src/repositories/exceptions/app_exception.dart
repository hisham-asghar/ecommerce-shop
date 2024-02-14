import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'app_exception.freezed.dart';

@freezed
class AppException with _$AppException {
  // unknown
  const factory AppException.unknown(Object error, StackTrace stackTrace) =
      Unknown;
  // Auth
  const factory AppException.invalidEmail(String? message) = InvalidEmail;
  const factory AppException.emailAlreadyInUse(String? message) =
      EmailAlreadyInUse;
  const factory AppException.weakPassword(String? message) = WeakPassword;
  const factory AppException.operationNotAllowed(String? message) =
      OperationNotAllowed;
  const factory AppException.wrongPassword(String? message) = WrongPassword;
  const factory AppException.userNotFound(String? message) = UserNotFound;
  const factory AppException.userDisabled(String? message) = UserDisabled;
  const factory AppException.tooManyAuthRequests(String? message) =
      TooManyAuthRequests;

  // Database
  const factory AppException.permissionDenied(String message) =
      PermissionDenied;

  // Functions
  const factory AppException.functions(String message) = Functions;

  // Payments
  const factory AppException.paymentFailed(String? message) = PaymentFailed;
  const factory AppException.paymentCanceled(String? message) = PaymentCanceled;

  // Other logical errors
  const factory AppException.missingAddress() = MissingAddress;
  const factory AppException.userNotSignedIn() = UserNotSignedIn;
}

extension AppExceptionMessage on AppException {
  String message(AppLocalizations loc) {
    return when(
      // unknown
      unknown: (e, st) => loc.anErrorOccurred,
      // auth
      invalidEmail: (message) => message ?? loc.invalidEmail,
      emailAlreadyInUse: (message) => message ?? loc.emailAlreadyInUse,
      weakPassword: (message) => message ?? loc.weakPassword,
      operationNotAllowed: (message) => message ?? loc.operationNotAllowed,
      wrongPassword: (message) => message ?? loc.wrongPassword,
      userNotFound: (message) => message ?? loc.userNotFound,
      userDisabled: (message) => message ?? loc.userDisabled,
      tooManyAuthRequests: (message) => message ?? loc.tooManyAuthRequests,
      // database
      permissionDenied: (message) => message,
      // functions
      functions: (message) => message,
      // payments
      paymentFailed: (message) => message ?? loc.couldNotPlaceOrder,
      paymentCanceled: (message) => message ?? loc.couldNotPlaceOrder,
      missingAddress: () => loc.missingAddress,
      userNotSignedIn: () => loc.userNotSignedIn,
    );
  }
}
