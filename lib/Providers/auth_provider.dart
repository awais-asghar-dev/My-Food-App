import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_food_app/Database/database_helper.dart';
import 'package:my_food_app/Models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get errorMessage => _errorMessage;

  // Check if user is logged in from SharedPreferences
  Future<void> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId != null) {
        final db = await DatabaseHelper().database;
        final userData = await db.query(
          'users',
          where: 'id = ?',
          whereArgs: [userId],
        );

        if (userData.isNotEmpty) {
          _currentUser = User.fromMap(userData.first);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error checking login status: $e');
    }
  }

  // Login method
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final db = await DatabaseHelper().database;
      final users = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (users.isEmpty) {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = User.fromMap(users.first);

      // Save login status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', _currentUser!.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Signup method
  Future<bool> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? address,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final db = await DatabaseHelper().database;

      // Check if email already exists
      final existingUsers = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (existingUsers.isNotEmpty) {
        _errorMessage = 'Email already exists';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Insert new user
      final userId = await db.insert('users', {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'address': address,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Create user object
      _currentUser = User(
        id: userId,
        name: name,
        email: email,
        phone: phone,
        address: address,
      );

      // Save login status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Signup failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');

    _currentUser = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}