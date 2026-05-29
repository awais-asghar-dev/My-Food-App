import 'package:flutter/foundation.dart';
import 'package:my_food_app/Database/database_helper.dart';
import 'package:my_food_app/Models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _products;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String? get errorMessage => _errorMessage;

  List<String> get categories {
    Set<String> categories = {'All'};
    for (var product in _products) {
      categories.add(product.category);
    }
    return categories.toList();
  }

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final db = await DatabaseHelper().database;
      final maps = await db.query('products');

      if (maps.isEmpty) {
        print('No products found in database');
        _errorMessage = 'No products available';
      } else {
        _products = maps.map((map) => Product.fromMap(map)).toList();
        _filteredProducts = List.from(_products);
        print('Loaded ${_products.length} products from database');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load products: $e';
      notifyListeners();
      print('Error loading products: $e');
    }
  }

  Future<void> toggleFavorite(int productId) async {
    try {
      final db = await DatabaseHelper().database;
      final index = _products.indexWhere((p) => p.id == productId);

      if (index != -1) {
        _products[index].isFavorite = !_products[index].isFavorite;
        await db.update(
          'products',
          {'isFavorite': _products[index].isFavorite ? 1 : 0},
          where: 'id = ?',
          whereArgs: [productId],
        );

        _applyFilter();
        notifyListeners();
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_selectedCategory == 'All') {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products
          .where((product) => product.category == _selectedCategory)
          .toList();
    }
  }

  List<Product> getFavoriteProducts() {
    return _products.where((product) => product.isFavorite).toList();
  }
}