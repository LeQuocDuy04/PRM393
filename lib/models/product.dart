class Product {
  final int id;
  final String title;
  final String description;
  final String image;
  final double price;
  final String category;
  final double rating;
  final int ratingCount;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    this.category = '',
    this.rating = 0,
    this.ratingCount = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingJson = json['rating'];
    final ratingMap = ratingJson is Map<String, dynamic> ? ratingJson : <String, dynamic>{};

    return Product(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      category: (json['category'] ?? '').toString(),
      rating: (ratingMap['rate'] as num?)?.toDouble() ?? 0,
      ratingCount: (ratingMap['count'] as num?)?.toInt() ?? 0,
    );
  }
}
