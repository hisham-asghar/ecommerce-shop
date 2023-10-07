import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';

class OrderStatusDropDown extends ConsumerWidget {
  const OrderStatusDropDown({Key? key, required this.value, this.onChanged})
      : super(key: key);
  final OrderStatus value;
  final ValueChanged<OrderStatus?>? onChanged;

  // TODO: Update order

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text('Status:', style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(width: Sizes.p16),
        DropdownButton<OrderStatus>(
          value: value,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          underline: Container(
            height: 2,
            color: Theme.of(context).primaryColor,
          ),
          onChanged: onChanged,
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
