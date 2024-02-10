// main.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_exception.freezed.dart';

@freezed
class AuthException with _$AuthException {
  const factory AuthException.unknown() = Unknown;
  const factory AuthException.invalidEmail() = InvalidEmail;
  const factory AuthException.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AuthException.weakPassword() = WeakPassword;
  const factory AuthException.operationNotAllowed() = OperationNotAllowed;
  const factory AuthException.wrongPassword() = WrongPassword;
  const factory AuthException.userNotFound() = UserNotFound;
  const factory AuthException.userDisabled() = UserDisabled;
}
