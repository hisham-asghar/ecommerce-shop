class AddToCartState {
  AddToCartState({
    required this.quantity,
    required this.isLoading,
  });
  final int quantity;
  final bool isLoading;

  AddToCartState copyWith({
    int? quantity,
    bool? isLoading,
  }) {
    return AddToCartState(
      quantity: quantity ?? this.quantity,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() =>
      'AddToCartState(quantity: $quantity, isLoading: $isLoading)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddToCartState &&
        other.quantity == quantity &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode => quantity.hashCode ^ isLoading.hashCode;
}
