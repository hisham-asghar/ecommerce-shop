typedef ProductID = String;

class Product {
  const Product({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.availableQuantity,
    this.avgRating = 0,
    this.numRatings = 0,
  });

  /// Unique id
  final ProductID id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final int availableQuantity;
  final double avgRating;
  final int numRatings;

  Product copyWith({
    ProductID? id,
    String? imageUrl,
    String? title,
    String? description,
    double? price,
    int? availableQuantity,
    double? avgRating,
    int? numRatings,
  }) {
    return Product(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      avgRating: avgRating ?? this.avgRating,
      numRatings: numRatings ?? this.numRatings,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, imageUrl: $imageUrl, title: $title, description: $description, price: $price, availableQuantity: $availableQuantity, avgRating: $avgRating, numRatings: $numRatings)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'price': price,
      'availableQuantity': availableQuantity,
      'avgRating': avgRating,
      'numRatings': numRatings,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, ProductID id) {
    return Product(
      id: id,
      imageUrl: map['imageUrl'],
      title: map['title'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      availableQuantity: (map['availableQuantity'] as num).toInt(),
      avgRating: (map['avgRating'] as num?)?.toDouble() ?? 0,
      numRatings: (map['numRatings'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.imageUrl == imageUrl &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        other.availableQuantity == availableQuantity &&
        other.avgRating == avgRating &&
        other.numRatings == numRatings;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        imageUrl.hashCode ^
        title.hashCode ^
        description.hashCode ^
        price.hashCode ^
        availableQuantity.hashCode ^
        avgRating.hashCode ^
        numRatings.hashCode;
  }
}
