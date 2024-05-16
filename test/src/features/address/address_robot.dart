import 'package:flutter_test/flutter_test.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/presentation/address_screen.dart';

class AddressRobot {
  AddressRobot(this.tester);
  final WidgetTester tester;

  // address
  Future<void> enterAddress() async {
    for (final key in [
      AddressScreen.addressKey,
      AddressScreen.townCityKey,
      AddressScreen.stateKey,
      AddressScreen.postalCodeKey,
      AddressScreen.countryKey,
    ]) {
      final finder = find.byKey(key);
      expect(finder, findsOneWidget);
      await tester.enterText(finder, 'a');
    }

    // https://stackoverflow.com/questions/67128148/flutter-widget-test-finder-fails-because-the-widget-is-outside-the-bounds-of-the
    // https://stackoverflow.com/questions/68366138/flutter-widget-test-tap-would-not-hit-test-on-the-specified-widget
    // https://stackoverflow.com/questions/56291806/flutter-how-to-test-the-scroll/67990754#67990754
    // scroll down so that the submit button is visible
    final scrollableFinder = find.byKey(AddressScreen.scrollableKey);
    expect(scrollableFinder, findsOneWidget);
    final ctaFinder = find.text('Submit', skipOffstage: false);
    await tester.dragUntilVisible(
      ctaFinder, // what you want to find
      scrollableFinder, // widget you want to scroll
      const Offset(0, -100), // delta to move
    );
    await tester.tap(ctaFinder);
    await tester.pumpAndSettle();
  }
}
