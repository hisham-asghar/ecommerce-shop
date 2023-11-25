import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_status/order_status_drop_down_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/entities/order.dart';
import 'package:my_shop_ecommerce_flutter/src/services/admin_orders_service.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class MockAdminOrdersRepository extends Mock implements AdminOrdersService {}

Order _fakeOrder() => Order(
      id: '123',
      userId: 'abc',
      items: [],
      orderStatus: OrderStatus.confirmed,
      orderDate: DateTime(2021, 10, 15),
      total: 100,
    );

void main() {
  group('OrderStatusDropDownModel - updateOrderStatus', () {
    test('success', () async {
      // setup
      final order = _fakeOrder();
      const status = OrderStatus.delivered;
      final updatedOrder = order.copyWith(orderStatus: status);
      final repository = MockAdminOrdersRepository();
      // simulate success
      when(() => repository.updateOrderStatus(updatedOrder))
          .thenAnswer((_) => Future<void>.value());
      final observedStates = <WidgetBasicState>[];
      final model = OrderStatusDropDownController(
        adminOrdersRepository: repository,
        order: order,
      );
      // track all state chanegs
      model.addListener(observedStates.add);
      // run
      await model.updateOrderStatus(status);
      // verify
      verify(() => repository.updateOrderStatus(updatedOrder));
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
      final repository = MockAdminOrdersRepository();
      // simulate failure: throw error
      when(() => repository.updateOrderStatus(updatedOrder))
          .thenThrow(StateError('User is not signed in'));
      final observedStates = <WidgetBasicState>[];
      final model = OrderStatusDropDownController(
        adminOrdersRepository: repository,
        order: _fakeOrder(),
      );
      // track all state chanegs
      model.addListener(observedStates.add);
      // run
      await model.updateOrderStatus(status);
      // verify
      verify(() => repository.updateOrderStatus(updatedOrder));
      expect(observedStates, const [
        WidgetBasicState.notLoading(), // initial state
        WidgetBasicState.loading(), // updateOrderStatus - try
        WidgetBasicState.error('Could not update order status'),
        WidgetBasicState.notLoading(), // updateOrderStatus - finally
      ]);
    });
  });
}
