class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  bool isFavorite;
  final String preparationTime;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    this.isFavorite = false,
    required this.preparationTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'isFavorite': isFavorite ? 1 : 0,
      'preparationTime': preparationTime,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'].toDouble(),
      imageUrl: map['imageUrl'],
      category: map['category'],
      rating: map['rating'].toDouble(),
      isFavorite: map['isFavorite'] == 1,
      preparationTime: map['preparationTime'],
    );
  }
}