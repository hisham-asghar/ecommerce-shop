import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('integration - full purchase flow', (tester) async {
    final r = Robot(tester);
    await r.pumpWidgetAppWithMocks();
    await r.selectProduct();
    await r.setProductQuantity(5);
    await r.addToCart();
    await r.openCart();
    r.expectFindNCartItems(1);
    await r.startCheckout();
    await r.signIn();
    await r.enterAddress();
    await r.startPayment();
    await r.payWithCard();
    r.expectPaymentComplete();
    await r.closePage();
  });
}
