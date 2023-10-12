class Product {
  Product({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.availableQuantity,
  });

  /// Unique id
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final int availableQuantity;
  // TODO: Add reviews

  Product copyWith({
    String? id,
    String? imageUrl,
    String? title,
    String? description,
    double? price,
    int? availableQuantity,
  }) =>
      Product(
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        availableQuantity: availableQuantity ?? this.availableQuantity,
      );

  @override
  String toString() {
    return 'Product(title: $title, price: $price)';
  }
}
