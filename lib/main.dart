import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_food_app/Database/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:my_food_app/Pages/splash_screen.dart';
import 'package:my_food_app/Pages/home_page.dart';
import 'package:my_food_app/Pages/product_page.dart';
import 'package:my_food_app/Pages/cart_page.dart';
import 'package:my_food_app/Pages/Categories.dart';
import 'package:my_food_app/Pages/profile_page.dart';
import 'package:my_food_app/Pages/setting_page.dart';
import 'package:my_food_app/Pages/auth/login_page.dart';
import 'package:my_food_app/Pages/auth/signup_page.dart';
import 'package:my_food_app/Providers/auth_provider.dart';
import 'package:my_food_app/Providers/cart_provider.dart';
import 'package:my_food_app/Providers/product_provider.dart';
import 'package:my_food_app/Widgets/database_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Initialize sqflite for web using sqflite_common_ffi_web
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'FoodExpress',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.orange),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash', // Add this
        routes: {
          '/splash': (context) => DatabaseInitializer( // Add splash route
            child: const SplashScreen(),
          ),
          '/': (context) => const MainWrapper(),
          '/products': (context) => const ProductsPage(),
          '/cart': (context) => const CartPage(),
          '/settings': (context) => const SettingsPage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
        },
      ),
    );
  }
}

// ... Rest of the MainWrapper code remains the same ...

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProductsPage(),
    const CategoriesPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  final List<String> _pageTitles = [
    'Home',
    'Products',
    'Categories',
    'Cart',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    // Data is now initialized in SplashScreen
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_pageTitles[_selectedIndex]),
      //   actions: _selectedIndex == 3 // Cart page
      //       ? []
      //       : [
      //     if (_selectedIndex != 4) // Not profile page
      //       Stack(
      //         children: [
      //           IconButton(
      //             icon: const Icon(Icons.shopping_cart_outlined),
      //             onPressed: () {
      //               setState(() {
      //                 _selectedIndex = 3;
      //               });
      //             },
      //           ),
      //           if (cartProvider.itemCount > 0)
      //             Positioned(
      //               right: 8,
      //               top: 8,
      //               child: Container(
      //                 padding: const EdgeInsets.all(2),
      //                 decoration: const BoxDecoration(
      //                   color: Colors.red,
      //                   shape: BoxShape.circle,
      //                 ),
      //                 constraints: const BoxConstraints(
      //                   minWidth: 16,
      //                   minHeight: 16,
      //                 ),
      //                 child: Text(
      //                   cartProvider.itemCount.toString(),
      //                   style: const TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 10,
      //                     fontWeight: FontWeight.bold,
      //                   ),
      //                   textAlign: TextAlign.center,
      //                 ),
      //               ),
      //             ),
      //         ],
      //       ),
      //   ],
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? Icons.fastfood : Icons.fastfood_outlined,
            ),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? Icons.category : Icons.category_outlined,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(
                  _selectedIndex == 3
                      ? Icons.shopping_cart
                      : Icons.shopping_cart_outlined,
                ),
                if (cartProvider.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 4 ? Icons.person : Icons.person_outline,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}