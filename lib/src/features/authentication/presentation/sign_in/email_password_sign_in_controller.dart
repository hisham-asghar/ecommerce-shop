import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:my_shop_ecommerce_flutter/src/exceptions/app_exception.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_provider.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/application/auth_service.dart';

class EmailPasswordSignInController
    extends StateNotifier<EmailPasswordSignInState> {
  EmailPasswordSignInController({
    required this.authService,
    required this.localizations,
    required EmailPasswordSignInFormType formType,
  }) : super(EmailPasswordSignInState(
            formType: formType, localizations: localizations));
  final AuthService authService;
  final AppLocalizations localizations;

  Future<Result<String, void>> submit(String email, String password) async {
    state = state.copyWith(isLoading: true);
    final result = await _submit(email, password);
    state = state.copyWith(isLoading: false);
    return result.when(
      (error) => Error(error.message(localizations)),
      (_) => const Success(null),
    );
  }

  Future<Result<AppException, void>> _submit(String email, String password) {
    switch (state.formType) {
      case EmailPasswordSignInFormType.signIn:
        return authService.signInWithEmailAndPassword(email, password);
      case EmailPasswordSignInFormType.register:
        return authService.createUserWithEmailAndPassword(email, password);
      case EmailPasswordSignInFormType.forgotPassword:
        return authService.sendPasswordResetEmail(email);
    }
  }

  void updateFormType(EmailPasswordSignInFormType formType) {
    state = state.copyWith(
      formType: formType,
      isLoading: false,
    );
  }
}

final emailPasswordSignInControllerProvider = StateNotifierProvider.autoDispose
    .family<EmailPasswordSignInController, EmailPasswordSignInState,
        EmailPasswordSignInFormType>((ref, formType) {
  final authService = ref.watch(authServiceProvider);
  final localizations = ref.watch(appLocalizationsProvider);
  return EmailPasswordSignInController(
    authService: authService,
    localizations: localizations,
    formType: formType,
  );
});
