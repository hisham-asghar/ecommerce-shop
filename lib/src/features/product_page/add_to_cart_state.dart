import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class AddToCartState {
  AddToCartState({
    required this.quantity,
    required this.widgetState,
  });
  final int quantity;
  final WidgetBasicState widgetState;

  AddToCartState copyWith({
    int? quantity,
    WidgetBasicState? widgetState,
  }) {
    return AddToCartState(
      quantity: quantity ?? this.quantity,
      widgetState: widgetState ?? this.widgetState,
    );
  }

  @override
  String toString() =>
      'AddToCartState(quantity: $quantity, widgetState: $widgetState)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddToCartState &&
        other.quantity == quantity &&
        other.widgetState == widgetState;
  }

  @override
  int get hashCode => quantity.hashCode ^ widgetState.hashCode;
}
