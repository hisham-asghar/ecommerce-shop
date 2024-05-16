import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/presentation/home_app_bar/more_menu_button.dart';

class AuthRobot {
  AuthRobot(this.tester);
  final WidgetTester tester;

  // sign in
  Future<void> enterEmailAndPassword() async {
    final emailFinder = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailFinder, findsOneWidget);
    await tester.enterText(emailFinder, 'test@test.com');

    final passwordFinder = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(passwordFinder, findsOneWidget);
    await tester.enterText(passwordFinder, 'test@test.com');
  }

  Future<void> signIn() async {
    await enterEmailAndPassword();

    final ctaFinder = find.text('Sign in');
    expect(ctaFinder, findsOneWidget);
    await tester.tap(ctaFinder);
    await tester.pumpAndSettle();
  }

  Future<void> createAccount() async {
    await enterEmailAndPassword();

    final ctaFinder = find.text('Create an account');
    expect(ctaFinder, findsOneWidget);
    await tester.tap(ctaFinder);
    await tester.pumpAndSettle();
  }

  Future<void> openAccountPage() async {
    final finder = find.byKey(MoreMenuButton.accountKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> logout() async {
    final finder = find.text('Logout');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
}
