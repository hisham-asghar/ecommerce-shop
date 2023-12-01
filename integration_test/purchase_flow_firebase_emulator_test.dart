import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => WidgetController.hitTestWarningShouldBeFatal = true);

  testWidgets('integration - full purchase flow', (tester) async {
    final r = Robot(tester);
    await r.pumpWidgetAppWithFirebaseEmulator();
    await r.selectProduct();
    await r.setProductQuantity(3);
    await r.addToCart();
    await r.openCart();
    r.expectFindNCartItems(1);
    await r.startCheckout();
    await r.createAccount();
    await r.enterAddress();
    await r.startPayment();
    await r.payWithCard();
    r.expectPaymentComplete();
    await r.closePage();
  });
}
