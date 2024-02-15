import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/string_validators.dart';

enum EmailPasswordSignInFormType { signIn, register, forgotPassword }

class EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();
}

class EmailPasswordSignInState with EmailAndPasswordValidators {
  EmailPasswordSignInState({
    required this.localizations,
    this.formType = EmailPasswordSignInFormType.signIn,
    this.isLoading = false,
  });
  final AppLocalizations localizations;

  final EmailPasswordSignInFormType formType;
  final bool isLoading;

  EmailPasswordSignInState copyWith({
    EmailPasswordSignInFormType? formType,
    bool? isLoading,
  }) {
    return EmailPasswordSignInState(
      localizations: localizations,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() {
    return 'EmailPasswordSignInState(formType: $formType, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmailPasswordSignInState &&
        other.formType == formType &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode {
    return formType.hashCode ^ isLoading.hashCode;
  }
}

extension EmailPasswordSignInStateX on EmailPasswordSignInState {
  String get passwordLabelText {
    if (formType == EmailPasswordSignInFormType.register) {
      return localizations.password8CharactersLabel;
    }
    return localizations.passwordLabel;
  }

  // Getters
  String get primaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: localizations.createAnAccount,
      EmailPasswordSignInFormType.signIn: localizations.signIn,
      EmailPasswordSignInFormType.forgotPassword: localizations.sendResetLink,
    }[formType]!;
  }

  String get secondaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: localizations.haveAnAccount,
      EmailPasswordSignInFormType.signIn: localizations.needAnAccount,
      EmailPasswordSignInFormType.forgotPassword: localizations.backToSignIn,
    }[formType]!;
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    return <EmailPasswordSignInFormType, EmailPasswordSignInFormType>{
      EmailPasswordSignInFormType.register: EmailPasswordSignInFormType.signIn,
      EmailPasswordSignInFormType.signIn: EmailPasswordSignInFormType.register,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInFormType.signIn,
    }[formType]!;
  }

  String get errorAlertTitle {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: localizations.registrationFailed,
      EmailPasswordSignInFormType.signIn: localizations.signInFailed,
      EmailPasswordSignInFormType.forgotPassword:
          localizations.passwordResetFailed,
    }[formType]!;
  }

  String get title {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: localizations.register,
      EmailPasswordSignInFormType.signIn: localizations.signIn,
      EmailPasswordSignInFormType.forgotPassword: localizations.forgotPassword,
    }[formType]!;
  }

  bool canSubmitEmail(String email) {
    return emailSubmitValidator.isValid(email);
  }

  bool canSubmitPassword(String password) {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText = email.isEmpty
        ? localizations.invalidEmailEmpty
        : localizations.invalidEmail;
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(String password) {
    final bool showErrorText = !canSubmitPassword(password);
    final String errorText = password.isEmpty
        ? localizations.invalidPasswordEmpty
        : localizations.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }
}
