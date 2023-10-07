import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/admin_orders_repository.dart';

class OrderStatusDropDown extends ConsumerWidget {
  const OrderStatusDropDown({Key? key, required this.order}) : super(key: key);
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text('Status:', style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(width: Sizes.p16),
        DropdownButton<OrderStatus>(
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
              ref
                  .read(adminOrdersRepositoryProvider)
                  .updateOrderStatus(order, status);
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
        // TODO: Set delivery date
      ],
    );
  }
}
