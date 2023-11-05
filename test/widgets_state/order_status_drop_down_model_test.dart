import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_status/order_status_drop_down_model.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/admin_orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class MockAdminOrdersRepository extends Mock implements AdminOrdersRepository {}

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
      final repository = MockAdminOrdersRepository();
      // simulate success
      when(() => repository.updateOrderStatus(order, status))
          .thenAnswer((_) => Future<void>.value());
      final observedStates = <WidgetBasicState>[];
      final model = OrderStatusDropDownModel(
        adminOrdersRepository: repository,
        order: _fakeOrder(),
      );
      // track all state chanegs
      model.addListener(observedStates.add);
      // run
      await model.updateOrderStatus(status);
      // verify
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
      final repository = MockAdminOrdersRepository();
      // simulate failure: throw error
      when(() => repository.updateOrderStatus(order, status))
          .thenThrow(StateError('User is not signed in'));
      final observedStates = <WidgetBasicState>[];
      final model = OrderStatusDropDownModel(
        adminOrdersRepository: repository,
        order: _fakeOrder(),
      );
      // track all state chanegs
      model.addListener(observedStates.add);
      // run
      await model.updateOrderStatus(status);
      // verify
      expect(observedStates, const [
        WidgetBasicState.notLoading(), // initial state
        WidgetBasicState.loading(), // updateOrderStatus - try
        WidgetBasicState.error('Could not update order status'),
        WidgetBasicState.notLoading(), // updateOrderStatus - finally
      ]);
    });
  });
}
