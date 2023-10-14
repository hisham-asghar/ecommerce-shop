import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_status/order_status_drop_down_view_model.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';

class OrderStatusDropDown extends StatelessWidget {
  const OrderStatusDropDown({Key? key, required this.viewModel})
      : super(key: key);
  final OrderStatusDropDownViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Status:', style: Theme.of(context).textTheme.subtitle1),
        const SizedBox(width: Sizes.p16),
        SizedBox(
          height: Sizes.p48,
          child: ValueListenableBuilder(
            valueListenable: viewModel.isLoading,
            builder: (context, bool isLoading, _) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return DropdownButton<OrderStatus>(
                  value: viewModel.order.orderStatus,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                  onChanged: (status) {
                    if (status != null) {
                      viewModel.updateOrderStatus(status);
                    }
                  },
                  items: [
                    for (var status in OrderStatus.values)
                      DropdownMenuItem<OrderStatus>(
                        value: status,
                        child: Text(describeEnum(status)),
                      ),
                  ],
                );
              }
            },
          ),
        ),
        // TODO: Set delivery date
      ],
    );
  }
}
