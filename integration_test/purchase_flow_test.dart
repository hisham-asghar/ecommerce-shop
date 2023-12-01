import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() => WidgetController.hitTestWarningShouldBeFatal = true);

  testWidgets('integration - full purchase flow', (tester) async {
    final r = Robot(tester);
    await r.pumpWidgetAppWithMocks();
    await r.fullPurchaseFlow();
  });
}
