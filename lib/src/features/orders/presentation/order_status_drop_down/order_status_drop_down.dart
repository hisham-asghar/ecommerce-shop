import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/presentation/order_status_drop_down/order_status_drop_down_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders/domain/order.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

/// Drop down widget to edit the order status (available to admin users only).
class OrderStatusDropDown extends ConsumerWidget {
  const OrderStatusDropDown({Key? key, required this.order}) : super(key: key);
  // TODO: Make this reactive?
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // error handling
    ref.listen<VoidAsyncValue>(
      orderStatusDropDownControllerProvider(order),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(orderStatusDropDownControllerProvider(order));
    return Row(
      children: [
        Text(
          context.loc.status,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        gapW16,
        SizedBox(
          height: Sizes.p48,
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : DropdownButton<OrderStatus>(
                  value: order.orderStatus,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (status) {
                    if (status != null) {
                      final model = ref.read(
                          orderStatusDropDownControllerProvider(order)
                              .notifier);
                      model.updateOrderStatus(status);
                    }
                  },
                  items: [
                    for (var status in OrderStatus.values)
                      DropdownMenuItem<OrderStatus>(
                        value: status,
                        child: Text(describeEnum(status)),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
