import 'package:flutter/material.dart';
import 'package:my_food_app/Widgets/logo_home.dart';
import 'package:provider/provider.dart';
import 'package:my_food_app/Providers/product_provider.dart';
import 'package:my_food_app/Providers/cart_provider.dart';
import 'package:my_food_app/Widgets/product_card.dart';
import 'package:my_food_app/Widgets/custom_courasel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _carouselImages = [
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
    'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=800',
    'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=800',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Sticky Header ──────────────────────────────────────────
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: LogoHome()),
                  const SizedBox(width: 10),
                  Center(
                    child: Text(
                      "PAPARAZZI FOODS",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.5,
                        height: 2.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Scrollable Content ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Guest!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'What would you like to order?',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Badge(
                      label: Text(cartProvider.itemCount.toString()),
                      child: IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search food, restaurants...',
                    icon: Icon(Icons.search, color: Colors.grey[500]),
                    suffixIcon: Icon(Icons.filter_list, color: Colors.grey[500]),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Promo Carousel (Updated)
              CustomCarousel(
                imageUrls: _carouselImages,
                height: 250,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              const SizedBox(height: 20),

              // Categories
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: productProvider.categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: productProvider.selectedCategory == category,
                        onSelected: (selected) {
                          productProvider.filterByCategory(category);
                        },
                        selectedColor: Colors.orange,
                        labelStyle: TextStyle(
                          color: productProvider.selectedCategory == category
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Popular Items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Items',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/products');
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

// Updated product display with better error handling
              if (productProvider.isLoading)
                Container(
                  height: 200,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('Loading delicious food...'),
                      ],
                    ),
                  ),
                )
              else if (productProvider.errorMessage != null)
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 50, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          productProvider.errorMessage ?? 'Error loading products',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            productProvider.loadProducts();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (productProvider.products.isEmpty)
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.fastfood_outlined, size: 50, color: Colors.grey),
                          const SizedBox(height: 10),
                          const Text(
                            'No products available',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              productProvider.loadProducts();
                            },
                            child: const Text('Load Products'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                    // Responsive Grid
                    LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount;
                        if (constraints.maxWidth > 1200) {
                          crossAxisCount = 5;
                        } else if (constraints.maxWidth > 900) {
                          crossAxisCount = 4;
                        } else if (constraints.maxWidth > 600) {
                          crossAxisCount = 3;
                        } else {
                          crossAxisCount = 2;
                        }

                        double itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * 10) / crossAxisCount;
                        double childAspectRatio = itemWidth / 295;
                        if (childAspectRatio < 0.5) childAspectRatio = 0.5;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: childAspectRatio,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: productProvider.products.length,
                          itemBuilder: (context, index) {
                            final product = productProvider.products[index];
                            return ProductCard(product: product);
                          },
                        );
                      },
                    ),
                    // end of scrollable column children
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


