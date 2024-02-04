import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_state.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_provider.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';

enum EmailPasswordSignInFormType { signIn, register, forgotPassword }

class EmailPasswordSignInController
    extends StateNotifier<EmailPasswordSignInState> {
  EmailPasswordSignInController({
    required this.authService,
    required AppLocalizations localizations,
    required EmailPasswordSignInFormType formType,
  }) : super(EmailPasswordSignInState(
            formType: formType, localizations: localizations));
  final AuthService authService;

  Future<bool> submit(String email, String password) async {
    try {
      state = state.copyWith(submitted: true);
      if (!state.canSubmit(email, password)) {
        return false;
      }
      state = state.copyWith(isLoading: true);
      switch (state.formType) {
        case EmailPasswordSignInFormType.signIn:
          await authService.signInWithEmailAndPassword(email, password);
          break;
        case EmailPasswordSignInFormType.register:
          await authService.createUserWithEmailAndPassword(email, password);
          break;
        case EmailPasswordSignInFormType.forgotPassword:
          await authService.sendPasswordResetEmail(email);
          state = state.copyWith(isLoading: false);
          break;
      }
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  void update({required String email, required String password}) =>
      state = state.copyWith(email: email, password: password);

  void updateFormType(EmailPasswordSignInFormType formType) {
    state = state.copyWith(
      password: '', // reset the password only, not the email
      formType: formType,
      isLoading: false,
      submitted: false,
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
