import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/data/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_provider.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/domain/product.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminProductScreenController extends StateNotifier<VoidAsyncValue> {
  AdminProductScreenController(
      {required this.localizations,
      required this.productsRepository,
      this.product})
      : super(const VoidAsyncValue.data(null)) {
    init();
  }
  final AppLocalizations localizations;
  final ProductsRepository productsRepository;
  // TODO: Force rebuild or avoid mutable state?
  final Product? product;
  var title = '';
  var description = '';
  var price = 0.0;
  var availableQuantity = 0;
  var imageUrl = '';

  void init() {
    title = product?.title ?? '';
    description = product?.description ?? '';
    price = product?.price ?? 0.0;
    availableQuantity = product?.availableQuantity ?? 0;
    imageUrl = product?.imageUrl ?? '';
  }

  void reset() {
    title = '';
    description = '';
    price = 0.0;
    availableQuantity = 0;
    imageUrl = '';
  }

  Future<void> submit() async {
    try {
      state = const VoidAsyncValue.loading();
      if (product == null) {
        final newProduct = Product(
          id: '',
          title: title,
          description: description,
          price: price,
          availableQuantity: availableQuantity,
          imageUrl: imageUrl,
        );
        await productsRepository.createProduct(newProduct);
        // reset state for next time page is shown
        reset();
      } else {
        final updatedProduct = product!.copyWith(
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl,
          availableQuantity: availableQuantity,
        );
        await productsRepository.updateProduct(updatedProduct);
      }
    } catch (e) {
      state = VoidAsyncValue.error(localizations.couldNotSaveProduct);
    } finally {
      state = const VoidAsyncValue.data(null);
    }
  }
}

final adminProductScreenControllerProvider = StateNotifierProvider.family<
    AdminProductScreenController, VoidAsyncValue, Product?>((ref, product) {
  final localizations = ref.watch(appLocalizationsProvider);
  final productsRepository = ref.watch(productsRepositoryProvider);
  return AdminProductScreenController(
    localizations: localizations,
    productsRepository: productsRepository,
    product: product,
  );
});
