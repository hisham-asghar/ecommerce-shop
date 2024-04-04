import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/alert_dialogs.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/custom_text_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_scrollable_card.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/presentation/sign_in/string_validators.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';

/// Email & password sign in screen.
/// Wraps the [EmailPasswordSignInContents] widget below with a [Scaffold] and
/// [AppBar] with a title.
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
        onSignedIn: () => context.pop(),
      ),
    );
  }
}

/// A widget for email & password authentication, supporting the following:
/// - sign in
/// - register (create an account)
/// - forgot password
class EmailPasswordSignInContents extends ConsumerStatefulWidget {
  const EmailPasswordSignInContents({
    Key? key,
    this.onSignedIn,
    required this.formType,
  }) : super(key: key);
  final VoidCallback? onSignedIn;

  /// The default form type to use.
  final EmailPasswordSignInFormType formType;
  @override
  _EmailPasswordSignInContentsState createState() =>
      _EmailPasswordSignInContentsState();
}

class _EmailPasswordSignInContentsState
    extends ConsumerState<EmailPasswordSignInContents> {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passwordController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var _submitted = false;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(EmailPasswordSignInState state) async {
    setState(() => _submitted = true);
    // only submit the form if validation passes
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(
          emailPasswordSignInControllerProvider(widget.formType).notifier);
      // submit the form
      final result = await controller.submit(email, password);
      result.when(
        (error) => showExceptionAlertDialog(
          context: context,
          title: state.errorAlertTitle,
          exception: error,
        ),
        (success) async {
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
        },
      );
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
          key: _formKey,
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
                  enabled: !state.isLoading,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    !_submitted ? null : state.emailErrorText(email ?? ''),
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.light,
                onEditingComplete: () => _emailEditingComplete(state),
                inputFormatters: <TextInputFormatter>[
                  ValidatorInputFormatter(
                      editingValidator: EmailEditingRegexValidator()),
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
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) => !_submitted
                      ? null
                      : state.passwordErrorText(password ?? ''),
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
