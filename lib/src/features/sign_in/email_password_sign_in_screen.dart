import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/alert_dialogs.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/custom_text_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_scrollable_card.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/sign_in/email_password_sign_in_state.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/services/cart_service.dart';

class EmailPasswordSignInScreen extends ConsumerWidget {
  const EmailPasswordSignInScreen({Key? key, required this.formType})
      : super(key: key);
  final EmailPasswordSignInFormType formType;

  static const emailKey = Key('email');
  static const passwordKey = Key('password');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.loc.signIn)),
      body: EmailPasswordSignInContents(
        formType: formType,
        onSignedIn: () async {
          try {
            // TODO: Should this be moved to an authService class?
            await ref.read(cartServiceProvider).copyItemsToRemote();
          } catch (e, _) {
            // TODO: Report exception
            debugPrint(e.toString());
          }
          context.pop();
        },
      ),
    );
  }
}

class EmailPasswordSignInContents extends ConsumerStatefulWidget {
  const EmailPasswordSignInContents(
      {Key? key, this.onSignedIn, required this.formType})
      : super(key: key);
  final VoidCallback? onSignedIn;
  final EmailPasswordSignInFormType formType;
  @override
  _EmailPasswordSignInContentsState createState() =>
      _EmailPasswordSignInContentsState();
}

class _EmailPasswordSignInContentsState
    extends ConsumerState<EmailPasswordSignInContents> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passwordController.text;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSignInError(EmailPasswordSignInState state, dynamic exception) {
    showExceptionAlertDialog(
      context: context,
      title: state.errorAlertTitle,
      exception: exception,
    );
  }

  Future<void> _submit(EmailPasswordSignInState state) async {
    try {
      final controller = ref.read(
          emailPasswordSignInControllerProvider(widget.formType).notifier);
      final bool success = await controller.submit(email, password);
      if (success) {
        if (state.formType == EmailPasswordSignInFormType.forgotPassword) {
          await showAlertDialog(
            context: context,
            title: context.loc.resetLinkSentTitle,
            content: context.loc.resetLinkSentMessage,
            defaultActionText: context.loc.ok,
          );
        } else {
          widget.onSignedIn?.call();
        }
      }
    } catch (e) {
      _showSignInError(state, e);
    }
  }

  void _emailEditingComplete(EmailPasswordSignInState state) {
    if (state.canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete(EmailPasswordSignInState state) {
    if (!state.canSubmitEmail(email)) {
      _node.previousFocus();
      return;
    }
    _submit(state);
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    ref
        .read(emailPasswordSignInControllerProvider(widget.formType).notifier)
        .updateFormType(formType);
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(emailPasswordSignInControllerProvider(widget.formType));
    return ResponsiveScrollableCard(
      child: FocusScope(
        node: _node,
        child: Form(
          onChanged: () => ref
              .read(emailPasswordSignInControllerProvider(widget.formType)
                  .notifier)
              .update(
                email: _emailController.text,
                password: _passwordController.text,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              gapH8,
              // Email field
              TextFormField(
                key: EmailPasswordSignInScreen.emailKey,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: context.loc.emailLabel,
                  hintText: context.loc.emailHint,
                  errorText: state.emailErrorText(email),
                  enabled: !state.isLoading,
                ),
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.light,
                onEditingComplete: () => _emailEditingComplete(state),
                inputFormatters: <TextInputFormatter>[
                  state.emailInputFormatter,
                ],
              ),
              if (state.formType !=
                  EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
                gapH8,
                // Password field
                TextFormField(
                  key: EmailPasswordSignInScreen.passwordKey,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: state.passwordLabelText,
                    errorText: state.passwordErrorText(password),
                    enabled: !state.isLoading,
                  ),
                  obscureText: true,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _passwordEditingComplete(state),
                ),
              ],
              gapH8,
              PrimaryButton(
                text: state.primaryButtonText,
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : () => _submit(state),
              ),
              gapH8,
              CustomTextButton(
                text: state.secondaryButtonText,
                onPressed: state.isLoading
                    ? null
                    : () => _updateFormType(state.secondaryActionFormType),
              ),
              if (state.formType == EmailPasswordSignInFormType.signIn)
                CustomTextButton(
                  text: context.loc.forgotPasswordQuestion,
                  onPressed: state.isLoading
                      ? null
                      : () => _updateFormType(
                          EmailPasswordSignInFormType.forgotPassword),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
