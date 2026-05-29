import 'package:my_food_app/Models/product.dart';

class CartItem {
  final int id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': product.id,
      'quantity': quantity,
      'addedAt': DateTime.now().toIso8601String(),
    };
  }
}