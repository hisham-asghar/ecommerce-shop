class ShoppingCartItemState {
  ShoppingCartItemState({
    required this.isLoading,
  });
  final bool isLoading;

  ShoppingCartItemState copyWith({
    bool? isLoading,
  }) {
    return ShoppingCartItemState(
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() => 'ShoppingCartItemState(isLoading: $isLoading)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShoppingCartItemState && other.isLoading == isLoading;
  }

  @override
  int get hashCode => isLoading.hashCode;
}
