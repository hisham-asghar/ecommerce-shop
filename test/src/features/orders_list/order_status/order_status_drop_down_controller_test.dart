import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_status/order_status_drop_down_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

import '../../../../mocks.dart';

Order _fakeOrder() => Order(
      id: '123',
      userId: 'abc',
      items: [],
      orderStatus: OrderStatus.confirmed,
      orderDate: DateTime(2021, 10, 15),
      total: 100,
    );

void main() {
  group('OrderStatusDropDownController - updateOrderStatus', () {
    test('success', () async {
      // setup
      final order = _fakeOrder();
      const status = OrderStatus.delivered;
      final updatedOrder = order.copyWith(orderStatus: status);
      final service = MockAdminOrdersService();
      // simulate success
      when(() => service.updateOrderStatus(updatedOrder))
          .thenAnswer((_) => Future<void>.value());
      final observedStates = <VoidAsyncValue>[];
      final model = OrderStatusDropDownController(
        adminOrdersService: service,
        order: order,
      );
      // track all state chanegs
      model.addListener(observedStates.add);
      // run
      await model.updateOrderStatus(status);
      // verify
      verify(() => service.updateOrderStatus(updatedOrder));
      expect(observedStates, const [
        VoidAsyncValue.data(null), // initial state
        VoidAsyncValue.loading(), // updateOrderStatus - try
        VoidAsyncValue.data(null), // updateOrderStatus - finally
      ]);
    });
    test('failure', () async {
      // setup
      final order = _fakeOrder();
      const status = OrderStatus.delivered;
      final updatedOrder = order.copyWith(orderStatus: status);
      final service = MockAdminOrdersService();
      // simulate failure: throw error
      when(() => service.updateOrderStatus(updatedOrder))
          .thenThrow(StateError('User is not signed in'));
      final observedStates = <VoidAsyncValue>[];
      final model = OrderStatusDropDownController(
        adminOrdersService: service,
        order: _fakeOrder(),
      );
      // track all state chanegs
      model.addListener(observedStates.add);
      // run
      await model.updateOrderStatus(status);
      // verify
      verify(() => service.updateOrderStatus(updatedOrder));
      expect(observedStates, const [
        VoidAsyncValue.data(null), // initial state
        VoidAsyncValue.loading(), // updateOrderStatus - try
        VoidAsyncValue.error('Could not update order status'),
        VoidAsyncValue.data(null), // updateOrderStatus - finally
      ]);
    });
  });
}
