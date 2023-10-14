import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/product_page/add_to_cart_state.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/cart_repository.dart';

class AddToCartViewModel extends StateNotifier<AddToCartState> {
  AddToCartViewModel({required this.cartRepository})
      : super(AddToCartState(quantity: 1, isLoading: false));
  final CartRepository cartRepository;

  void updateQuantity(int quantity) {
    state = state.copyWith(quantity: quantity);
  }

  Future<void> addItem(Product product) async {
    try {
      state = state.copyWith(isLoading: true);
      final item = Item(
        productId: product.id,
        quantity: state.quantity,
      );
      await cartRepository.addItem(item);
    } catch (e) {
      print(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final addToCartViewModelProvider =
    StateNotifierProvider<AddToCartViewModel, AddToCartState>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  return AddToCartViewModel(cartRepository: cartRepository);
});
