import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/products_repository.dart';
import 'package:uuid/uuid.dart';

class AdminProductScreenViewModel {
  AdminProductScreenViewModel(
      {required this.productsRepository, String? productId})
      : product = productId != null
            ? productsRepository.getProductById(productId)
            : null {
    init();
  }
  final ProductsRepository productsRepository;
  late final Product? product;
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

  Future<void> submit() async {
    if (product == null) {
      final newProduct = Product(
        id: const Uuid().v1(),
        title: title,
        description: description,
        price: price,
        availableQuantity: availableQuantity,
        imageUrl: imageUrl,
      );
      await productsRepository.addProduct(newProduct);
    } else {
      final updatedProduct = product!.copyWith(
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
        availableQuantity: availableQuantity,
      );
      await productsRepository.editProduct(updatedProduct);
    }
  }

  // VALIDATORS
  static String? imageUrlValidator(String? value) {
    if (value == null) {
      return 'Can\'t be empty';
    }
    final uri = Uri.tryParse(value);
    if (uri?.hasScheme != true) {
      return 'Not a valid URL';
    }
    return null;
  }

  static String? titleValidator(String? value) {
    if (value == null) {
      return 'Can\'t be empty';
    }
    if (value.length < 20) {
      return 'Minimum length: 20 characters';
    }
    return null;
  }

  static String? descriptionValidator(String? value) {
    if (value == null) {
      return 'Can\'t be empty';
    }
    if (value.length < 40) {
      return 'Minimum length: 40 characters';
    }
    return null;
  }

  static String? priceValidator(String? value) {
    if (value == null) {
      return 'Can\'t be empty';
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Not a valid number';
    }
    if (price <= 0) {
      return 'Price must be greater than zero';
    }
    if (price >= 100000) {
      return 'The maximum price must be less than \$100,000';
    }
    return null;
  }

  static String? availableQuantityValidator(String? value) {
    if (value == null) {
      return 'Can\'t be empty';
    }
    final availableQuantity = int.tryParse(value);
    if (availableQuantity == null) {
      return 'Not a valid number';
    }
    if (availableQuantity < 0) {
      return 'Quantity must be zero or more';
    }
    if (availableQuantity >= 1000) {
      return 'The maximum quantity must be less than 1,000';
    }
    return null;
  }
}
