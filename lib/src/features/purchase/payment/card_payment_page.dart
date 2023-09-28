import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/scrollable_page.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/auth_service.dart';
import 'package:my_shop_ecommerce_flutter/src/services/orders_manager.dart';
import 'package:uuid/uuid.dart';

/// Borrowed from flutter_stripe example app
class CardPaymentPage extends ConsumerStatefulWidget {
  const CardPaymentPage({Key? key, this.onOrderCompleted}) : super(key: key);
  final Function(Order order)? onOrderCompleted;

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => CardPaymentPage(
        onOrderCompleted: (order) => Navigator.of(context).pop(order),
      ),
      fullscreenDialog: true,
    );
  }

  @override
  _CardPaymentPageState createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends ConsumerState<CardPaymentPage> {
  final controller = CardFormEditController();

  // TODO: Review
  @override
  void initState() {
    controller.addListener(update);
    super.initState();
  }

  void update() => setState(() {});
  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  // TODO: Move this to more appropriate place
  void _placeOrder() async {
    final items = ref.read(cartProvider);
    final auth = ref.read(authServiceProvider);
    final ordersManager = ref.read(ordersProvider);
    final order = Order(
      id: Uuid().v1(),
      userId: auth.uid!, // safe to use ! as we must be logged in if we get here
      items: List.from(items),
      // TODO: Update with real payment status
      paymentStatus: PaymentStatus.paid,
      deliveryStatus: DeliveryStatus.notDelivered,
    );
    // TODO: Try catch...
    await ordersManager.placeOrder(order);
    widget.onOrderCompleted?.call(order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ScrollablePage(
        //padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO: Make this testable
            // TODO: Figure out how to support web: https://github.com/flutter-stripe/flutter_stripe/issues/36
            Platform.isIOS || Platform.isAndroid
                ? CardFormField(controller: controller)
                : const UnsupportedPlatformPaymentPlaceholder(),
            PrimaryButton(
              onPressed: controller.details.complete == true ||
                      !Platform.isIOS && !Platform.isAndroid
                  ? _placeOrder
                  : null,
              text: 'Pay',
            ),
            // Divider(),
            // Padding(
            //   padding: EdgeInsets.all(8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       OutlinedButton(
            //         onPressed: () => controller.focus(),
            //         child: Text('Focus'),
            //       ),
            //       SizedBox(width: 12),
            //       OutlinedButton(
            //         onPressed: () => controller.blur(),
            //         child: Text('Blur'),
            //       ),
            //     ],
            //   ),
            // ),
            // Divider(),
            // SizedBox(height: 20),
            // ResponseCard(
            //   response: controller.details.toJson().toPrettyString(),
            // )
          ],
        ),
      ),
    );
  }

  // TODO: Implement later
  // Future<void> _handlePayPress() async {
  //   if (!controller.details.complete) {
  //     return;
  //   }

  //   try {
  //     // 1. Gather customer billing information (ex. email)

  //     final billingDetails = BillingDetails(
  //       email: 'email@stripe.com',
  //       phone: '+48888000888',
  //       address: Address(
  //         city: 'Houston',
  //         country: 'US',
  //         line1: '1459  Circle Drive',
  //         line2: '',
  //         state: 'Texas',
  //         postalCode: '77063',
  //       ),
  //     ); // mocked data for tests

  //     // 2. Create payment method
  //     final paymentMethod =
  //         await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(
  //       billingDetails: billingDetails,
  //     ));

  //     // 3. call API to create PaymentIntent
  //     final paymentIntentResult = await callNoWebhookPayEndpointMethodId(
  //       useStripeSdk: true,
  //       paymentMethodId: paymentMethod.id,
  //       currency: 'usd', // mocked data
  //       items: [
  //         {'id': 'id'}
  //       ],
  //     );

  //     if (paymentIntentResult['error'] != null) {
  //       // Error during creating or confirming Intent
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Error: ${paymentIntentResult['error']}')));
  //       return;
  //     }

  //     if (paymentIntentResult['clientSecret'] != null &&
  //         paymentIntentResult['requiresAction'] == null) {
  //       // Payment succedeed

  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content:
  //               Text('Success!: The payment was confirmed successfully!')));
  //       return;
  //     }

  //     if (paymentIntentResult['clientSecret'] != null &&
  //         paymentIntentResult['requiresAction'] == true) {
  //       // 4. if payment requires action calling handleCardAction
  //       final paymentIntent = await Stripe.instance
  //           .handleCardAction(paymentIntentResult['clientSecret']);

  //       // todo handle error
  //       /*if (cardActionError) {
  //       Alert.alert(
  //       `Error code: ${cardActionError.code}`,
  //       cardActionError.message
  //       );
  //     } else*/

  //       if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
  //         // 5. Call API to confirm intent
  //         await confirmIntent(paymentIntent.id);
  //       } else {
  //         // Payment succedeed
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             content: Text('Error: ${paymentIntentResult['error']}')));
  //       }
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Error: $e')));
  //     rethrow;
  //   }
  // }

  // Future<void> confirmIntent(String paymentIntentId) async {
  //   final result = await callNoWebhookPayEndpointIntentId(
  //       paymentIntentId: paymentIntentId);
  //   if (result['error'] != null) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Error: ${result['error']}')));
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Success!: The payment was confirmed successfully!')));
  //   }
  // }

  // Future<Map<String, dynamic>> callNoWebhookPayEndpointIntentId({
  //   required String paymentIntentId,
  // }) async {
  //   final url = Uri.parse('$kApiUrl/charge-card-off-session');
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode({'paymentIntentId': paymentIntentId}),
  //   );
  //   return json.decode(response.body);
  // }

  // Future<Map<String, dynamic>> callNoWebhookPayEndpointMethodId({
  //   required bool useStripeSdk,
  //   required String paymentMethodId,
  //   required String currency,
  //   List<Map<String, dynamic>>? items,
  // }) async {
  //   final url = Uri.parse('$kApiUrl/pay-without-webhooks');
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode({
  //       'useStripeSdk': useStripeSdk,
  //       'paymentMethodId': paymentMethodId,
  //       'currency': currency,
  //       'items': items
  //     }),
  //   );
  //   return json.decode(response.body);
  // }
}

class UnsupportedPlatformPaymentPlaceholder extends StatelessWidget {
  const UnsupportedPlatformPaymentPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p32),
      child: Column(children: const [
        Placeholder(
          fallbackHeight: 200,
        ),
        SizedBox(height: Sizes.p16),
        Text(
          'Payment not supported on platform',
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}
