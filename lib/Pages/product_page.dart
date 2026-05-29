import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_food_app/Providers/product_provider.dart';
import 'package:my_food_app/Widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text('All Products')),
              const PopupMenuItem(value: 'Favorites', child: Text('Favorites Only')),
              const PopupMenuItem(value: 'Price: Low to High', child: Text('Price: Low to High')),
              const PopupMenuItem(value: 'Price: High to Low', child: Text('Price: High to Low')),
              const PopupMenuItem(value: 'Rating', child: Text('Highest Rating')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
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
                double childAspectRatio = itemWidth / 295;
                if (childAspectRatio < 0.5) childAspectRatio = 0.5;

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: productProvider.products.length,
                  itemBuilder: (context, index) {
                    final product = productProvider.products[index];
                    return ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}