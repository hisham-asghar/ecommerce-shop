import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_shop_ecommerce_flutter/src/features/orders_list/order_status_drop_down/order_status_drop_down_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/order.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

import '../../../../mocks.dart';

Order _fakeOrder() => Order(
      id: '123',
      userId: 'abc',
      items: {},
      orderStatus: OrderStatus.confirmed,
      orderDate: DateTime(2021, 10, 15),
      total: 100,
    );

void main() {
  final localizations = AppLocalizationsEn();
  group('OrderStatusDropDownController - updateOrderStatus', () {
    test('success', () async {
      // setup
      final order = _fakeOrder();
      const status = OrderStatus.delivered;
      final updatedOrder = order.copyWith(orderStatus: status);
      final repository = MockOrdersRepository();
      // simulate success
      when(() => repository.updateOrderStatus(updatedOrder))
          .thenAnswer((_) => Future<void>.value());
      final observedStates = <VoidAsyncValue>[];
      final model = OrderStatusDropDownController(
        localizations: localizations,
        ordersRepository: repository,
        order: order,
      );
      // track all state chanegs
      model.addListener(observedStates.add);
      // run
      await model.updateOrderStatus(status);
      // verify
      verify(() => repository.updateOrderStatus(updatedOrder));
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
      final repository = MockOrdersRepository();
      // simulate failure: throw error
      when(() => repository.updateOrderStatus(updatedOrder))
          .thenThrow(StateError('User is not signed in'));
      final observedStates = <VoidAsyncValue>[];
      final model = OrderStatusDropDownController(
        localizations: localizations,
        ordersRepository: repository,
        order: _fakeOrder(),
      );
      // track all state chanegs
      model.addListener(observedStates.add);
      // run
      await model.updateOrderStatus(status);
      // verify
      verify(() => repository.updateOrderStatus(updatedOrder));
      expect(observedStates, const [
        VoidAsyncValue.data(null), // initial state
        VoidAsyncValue.loading(), // updateOrderStatus - try
        VoidAsyncValue.error('Could not update order status'),
        VoidAsyncValue.data(null), // updateOrderStatus - finally
      ]);
    });
  });
}
