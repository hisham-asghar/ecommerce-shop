import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';

class Cart {
  const Cart([this.items = const {}]);
  /// All the items in the shopping cart, where:
  /// - key: product ID
  /// - value: quantity
  final Map<String, int> items;

  Map<String, dynamic> toMap() {
    return {
      'items': items,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(_parseItems(map['items']));
  }

  // Helper method for backwards compatibility
  // TODO: Simplify once data has been migrated
  static Map<String, int> _parseItems(dynamic value) {
    if (value is List<dynamic>) {
      final items = List<Item>.from(value.map((x) => Item.fromMap(x)));
      return Map<String, int>.fromEntries(
          items.map((item) => MapEntry(item.productId, item.quantity)));
    } else if (value is Map<String, dynamic>) {
      return Map<String, int>.from(value);
    } else {
      throw ArgumentError('Invalid items: $value');
    }
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() => 'Cart(items: $items)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cart && mapEquals(other.items, items);
  }

  @override
  int get hashCode => items.hashCode;
}

extension CartItems on Cart {
  List<Item> toItemsList() {
    return items.entries.map((entry) {
      return Item(
        productId: entry.key,
        quantity: entry.value,
      );
    }).toList();
  }
}
