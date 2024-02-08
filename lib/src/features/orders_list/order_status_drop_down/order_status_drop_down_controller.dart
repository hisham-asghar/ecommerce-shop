import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_provider.dart';
import 'package:my_shop_ecommerce_flutter/src/models/order.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/orders/orders_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderStatusDropDownController extends StateNotifier<VoidAsyncValue> {
  OrderStatusDropDownController({
    required this.localizations,
    required this.ordersRepository,
    required this.order,
  }) : super(const VoidAsyncValue.data(null));
  final AppLocalizations localizations;
  final OrdersRepository ordersRepository;

  final Order order;

  Future<void> updateOrderStatus(OrderStatus status) async {
    try {
      state = const VoidAsyncValue.loading();
      final updatedOrder = order.copyWith(orderStatus: status);
      await ordersRepository.updateOrderStatus(updatedOrder);
    } catch (e) {
      state = VoidAsyncValue.error(localizations.couldNotUpdateOrderStatus);
    } finally {
      state = const VoidAsyncValue.data(null);
    }
  }
}

final orderStatusDropDownControllerProvider = StateNotifierProvider.family<
    OrderStatusDropDownController, VoidAsyncValue, Order>((ref, order) {
  final localizations = ref.watch(appLocalizationsProvider);
  final adminOrdersRepository = ref.watch(ordersRepositoryProvider);
  return OrderStatusDropDownController(
    localizations: localizations,
    ordersRepository: adminOrdersRepository,
    order: order,
  );
});
