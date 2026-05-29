import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_food_app/Widgets/app_logo.dart';
import 'package:my_food_app/Providers/auth_provider.dart';
import 'package:my_food_app/Providers/product_provider.dart';
import 'package:my_food_app/Providers/cart_provider.dart';
import 'package:my_food_app/Database/database_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animations
    _controller.forward();

    // Initialize app data
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('Starting app initialization...');

      // Initialize database
      print('Initializing database...');
      final dbHelper = DatabaseHelper();
      await dbHelper.database;

      // Print database info for debugging
      await dbHelper.printDatabaseInfo();

      // Initialize providers
      print('Loading user session...');
      await Provider.of<AuthProvider>(context, listen: false).checkLoginStatus();

      print('Loading products...');
      await Provider.of<ProductProvider>(context, listen: false).loadProducts();

      print('Loading cart items...');
      await Provider.of<CartProvider>(context, listen: false).loadCartItems();

      print('App initialization completed successfully!');

      // Wait a minimum time for splash screen (2 seconds)
      await Future.delayed(const Duration(milliseconds: 5000));

      // Navigate to home
      _navigateToHome();

    } catch (e) {
      print('Error during app initialization: $e');

      // Even if there's an error, navigate after delay
      await Future.delayed(const Duration(milliseconds: 2000));
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const AppLogo(size: 120, withText: false),
                ),
              ),

              const SizedBox(height: 30),

              // App Name with Animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'PAPARAZZI-FOODS',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fast & Delicious',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Loading Indicator
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.orange[700]!,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Preparing delicious meals...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),

              // Developer Info (only in debug mode)
              if (const bool.fromEnvironment('dart.vm.product') == false) ...[
                const SizedBox(height: 40),
                Text(
                  'Food Delivery App',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}