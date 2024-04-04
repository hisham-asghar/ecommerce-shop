import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_provider.dart';

class ProductValidator {
  ProductValidator({required this.localizations});
  final AppLocalizations localizations;

  // VALIDATORS
  String? imageUrlValidator(String? value) {
    if (value == null) {
      return localizations.cantBeEmpty;
    }
    final uri = Uri.tryParse(value);
    if (uri?.hasScheme != true) {
      return localizations.invalidUrl;
    }
    return null;
  }

  String? titleValidator(String? value) {
    if (value == null) {
      return localizations.cantBeEmpty;
    }
    if (value.length < 20) {
      return localizations.minimumLength20Chars;
    }
    return null;
  }

  String? descriptionValidator(String? value) => titleValidator(value);

  String? priceValidator(String? value) {
    if (value == null) {
      return localizations.cantBeEmpty;
    }
    final price = double.tryParse(value);
    if (price == null) {
      return localizations.invalidNumber;
    }
    if (price <= 0) {
      return localizations.priceGreaterThanZero;
    }
    if (price >= 100000) {
      return localizations.priceLessThanMax;
    }
    return null;
  }

  String? availableQuantityValidator(String? value) {
    if (value == null) {
      return localizations.cantBeEmpty;
    }
    final availableQuantity = int.tryParse(value);
    if (availableQuantity == null) {
      return localizations.invalidNumber;
    }
    if (availableQuantity < 0) {
      return localizations.quantityGreaterThanZero;
    }
    if (availableQuantity >= 1000) {
      return localizations.quantityLessThanMax;
    }
    return null;
  }
}

final productValidatorProvider = Provider<ProductValidator>((ref) {
  final localizations = ref.watch(appLocalizationsProvider);
  return ProductValidator(localizations: localizations);
});
