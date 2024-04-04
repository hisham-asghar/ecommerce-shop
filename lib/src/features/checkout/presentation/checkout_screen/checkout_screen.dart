import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:my_shop_ecommerce_flutter/src/features/address/presentation/address_screen.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/presentation/checkout_screen/checkout_screen_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/checkout/presentation/payment_page/payment_page.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';

/// This is the root widget of the checkout flow, which is composed of 3 pages:
/// 1. Register page
/// 2. Address page
/// 3. Payment page
/// The correct page is displayed (and updated) based on two conditions:
/// - The user is signed in
/// - The user has entered an address
/// The logic for the entire flow is implemented in the
/// [CheckoutScreenController], while UI updates are handled by a
/// [PageController].
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _controller = PageController();
  @override
  Widget build(BuildContext context) {
    // listen to changes to the CheckoutSubRoute to animate between pages
    ref.listen<AsyncValue<CheckoutSubRoute>>(checkoutScreenControllerProvider,
        (previousState, state) {
      state.whenData((subRoute) async {
        if (previousState is AsyncLoading) {
          // if we have just loaded the data, jump to page without animation
          _controller.jumpToPage(subRoute.index);
        } else {
          // else, animate to the new page
          _controller.animateToPage(
            subRoute.index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        }
      });
    });
    final state = ref.watch(checkoutScreenControllerProvider);
    return state.when(data: (subRoute) {
      // map subRoute to address
      final title = {
        CheckoutSubRoute.address: context.loc.address,
        CheckoutSubRoute.payment: context.loc.payment,
        CheckoutSubRoute.register: context.loc.register
      }[subRoute]!;
      // return Scaffold with PageView
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
            EmailPasswordSignInContents(
              formType: EmailPasswordSignInFormType.register,
              onSignedIn: () => ref
                  .read(checkoutScreenControllerProvider.notifier)
                  .updateSubRoute(),
            ),
            AddressScreen(
              onDataSubmitted: () => ref
                  .read(checkoutScreenControllerProvider.notifier)
                  .updateSubRoute(),
            ),
            const PaymentPage()
          ],
        ),
      );
    }, loading: () {
      // * Note: return Scaffold with PageView even for the loading state.
      // * This is needed to prevent a "PageController not used" warning
      return Scaffold(
        appBar: AppBar(),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: const [
            Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }, error: (e, st) {
      // * Note: return Scaffold with PageView even for the error state.
      // * Rhis is needed to prevent a "PageController not used" warning
      return Scaffold(
        appBar: AppBar(),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
            AsyncValueErrorWidget(e, st),
          ],
        ),
      );
    });
  }
}
