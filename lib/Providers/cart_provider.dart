import 'package:flutter/foundation.dart';
import 'package:my_food_app/Database/database_helper.dart' hide DatabaseHelper;
import 'package:my_food_app/Models/product.dart';

import '../Database/database_helper.dart';
import '../Models/product.dart' hide Product;

class CartProvider with ChangeNotifier {
  List<Product> _cartItems = [];
  double _totalAmount = 0.0;

  List<Product> get cartItems => _cartItems;
  double get totalAmount => _totalAmount;
  int get itemCount => _cartItems.length;

  Future<void> loadCartItems() async {
    final db = await DatabaseHelper().database;
    final maps = await db.query('cart_items');

    _cartItems.clear();
    for (var map in maps) {
      final productMaps = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [map['productId']],
      );

      if (productMaps.isNotEmpty) {
        final product = Product.fromMap(productMaps.first);
        _cartItems.add(product);
      }
    }

    _calculateTotal();
    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    final db = await DatabaseHelper().database;

    final existing = await db.query(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [product.id],
    );

    if (existing.isEmpty) {
      await db.insert('cart_items', {
        'productId': product.id,
        'quantity': 1,
        'addedAt': DateTime.now().toIso8601String(),
      });
    }

    await loadCartItems();
  }

  Future<void> removeFromCart(int productId) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    await loadCartItems();
  }

  Future<void> clearCart() async {
    final db = await DatabaseHelper().database;
    await db.delete('cart_items');

    _cartItems.clear();
    _totalAmount = 0.0;
    notifyListeners();
  }

  void _calculateTotal() {
    _totalAmount = _cartItems.fold(
      0.0,
          (total, product) => total + product.price,
    );
  }
}