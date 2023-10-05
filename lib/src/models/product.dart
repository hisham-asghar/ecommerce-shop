class Product {
  Product({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
  });

  /// Unique id
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  // TODO: Add reviews

  @override
  String toString() {
    return 'Product(title: $title, price: $price)';
  }
}
