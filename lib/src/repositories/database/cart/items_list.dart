import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/cart/item.dart';

// TODO: This is no longer needed?
class ItemsList {
  ItemsList(this.items);
  final List<Item> items;

  @override
  int get hashCode => items.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemsList && listEquals(other.items, items);
  }

  @override
  String toString() => 'ItemsList(items: $items)';

  ItemsList copyWith({
    List<Item>? items,
  }) {
    return ItemsList(
      items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory ItemsList.fromMap(Map<String, dynamic> map) {
    return ItemsList(
      List<Item>.from(map['items']?.map((x) => Item.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemsList.fromJson(String source) =>
      ItemsList.fromMap(json.decode(source));
}
