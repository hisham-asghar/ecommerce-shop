import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'robot.dart';

void main() {
  // https://stackoverflow.com/a/57998506/436422
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('full purchase flow', (tester) async {
    final r = Robot(tester);
    await r.pumpWidgetAppWithMocks();
    await r.fullPurchaseFlow();
  });
}
