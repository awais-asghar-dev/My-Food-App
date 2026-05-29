import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_food_app/Providers/product_provider.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categories = productProvider.categories
        .where((cat) => cat != 'All')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: LayoutBuilder(
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

          double itemWidth = (constraints.maxWidth - 32 - (crossAxisCount - 1) * 16) / crossAxisCount;
          double childAspectRatio = itemWidth / 150;
          if (childAspectRatio < 0.5) childAspectRatio = 0.5;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final products = productProvider.allProducts
                  .where((p) => p.category == category)
                  .toList();

              return _buildCategoryCard(context, category, products.length);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category, int itemCount) {
    final categoryImages = {
      'Italian': 'https://images.unsplash.com/photo-1598866594230-a7c12756260f?w=400',
      'Fast Food': 'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?w=400',
      'Salads': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
      'Japanese': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      'Desserts': 'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=400',
      'Indian': 'https://images.unsplash.com/photo-1585937421612-70ca003675ed?w=400',
      'Appetizers': 'https://images.unsplash.com/photo-1541532713592-79a0317b6b77?w=400',
      'Mexican': 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400',
      'Vegetarian': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
      'Seafood': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400',
      'Steakhouse': 'https://images.unsplash.com/photo-1600891964092-4316c288032e?w=400',
      'Middle Eastern': 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400',
      'Beverages': 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=400',
      'Sides': 'https://images.unsplash.com/photo-1534080391025-0979e8304b27?w=400',
      'Chinese': 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=400',
      'Continental': 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400',
      'Breakfast': 'https://images.unsplash.com/photo-1533089860891-a7c6f0c88b90?w=400',
      'Bakery': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Provider.of<ProductProvider>(context, listen: false)
              .filterByCategory(category);
          Navigator.pushNamed(context, '/products');
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                categoryImages[category] ?? 'https://images.unsplash.com/photo-1490818387583-1baba5e638af?w=400',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.orange.shade100,
                    child: Center(
                      child: Icon(Icons.restaurant, color: Colors.orange.shade700, size: 40),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.orange.shade50,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$itemCount items',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}