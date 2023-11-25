import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_status/order_status_drop_down_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/admin_orders_service.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class MockAdminOrdersService extends Mock implements AdminOrdersService {}

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
      final observedStates = <WidgetBasicState>[];
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
        WidgetBasicState.notLoading(), // initial state
        WidgetBasicState.loading(), // updateOrderStatus - try
        WidgetBasicState.notLoading(), // updateOrderStatus - finally
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
      final observedStates = <WidgetBasicState>[];
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
        WidgetBasicState.notLoading(), // initial state
        WidgetBasicState.loading(), // updateOrderStatus - try
        WidgetBasicState.error('Could not update order status'),
        WidgetBasicState.notLoading(), // updateOrderStatus - finally
      ]);
    });
  });
}
