import 'package:flutter/material.dart';
import 'package:my_food_app/Models/user.dart';
import 'package:provider/provider.dart';
import 'package:my_food_app/Providers/auth_provider.dart';
import 'package:my_food_app/Providers/product_provider.dart';
import 'package:my_food_app/Providers/cart_provider.dart';
import 'package:my_food_app/Models/product.dart';
import 'package:my_food_app/Pages/auth/login_page.dart';
import 'package:my_food_app/Pages/setting_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    // If user is not logged in, show guest profile
    if (!authProvider.isLoggedIn) {
      return _buildGuestProfile(context);
    }

    // If user is logged in, show user profile
    final favoriteProducts = productProvider.getFavoriteProducts();
    return _buildUserProfile(context, authProvider, favoriteProducts, cartProvider);
  }

  // Guest Profile View
  Widget _buildGuestProfile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Guest Header
            Container(
              padding: const EdgeInsets.all(30),
              color: Colors.orange.withOpacity(0.1),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(
                      Icons.person_outline,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome Guest!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Login or create an account to access all features',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem('Cart Items', '0'),
                      const SizedBox(width: 30),
                      _buildStatItem('Favorites', '0'),
                      const SizedBox(width: 30),
                      _buildStatItem('Orders', '0'),
                    ],
                  ),
                ],
              ),
            ),

            // Login/Signup Section
            Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 50,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Unlock Full Features',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'By creating an account you can:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Features List
                  _buildFeatureItem(
                    Icons.shopping_cart_outlined,
                    'Save your cart items',
                    'Your cart items will be saved across devices',
                  ),
                  _buildFeatureItem(
                    Icons.favorite_outline,
                    'Save favorite items',
                    'Quickly reorder your favorite meals',
                  ),
                  _buildFeatureItem(
                    Icons.history_outlined,
                    'Track order history',
                    'View and reorder from your past orders',
                  ),
                  _buildFeatureItem(
                    Icons.local_offer_outlined,
                    'Get exclusive offers',
                    'Receive personalized discounts and promotions',
                  ),

                  const SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              onLoginSuccess: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Login / Sign Up',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Continue as Guest
                  TextButton(
                    onPressed: () {
                      // Continue as guest
                    },
                    child: Text(
                      'Continue as Guest',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // App Info
            Container(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                'Food Delivery App v1.0.0',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // User Profile View
  Widget _buildUserProfile(
      BuildContext context,
      AuthProvider authProvider,
      List<Product> favoriteProducts,
      CartProvider cartProvider,
      ) {
    final user = authProvider.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.orange.withOpacity(0.1),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.orange,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  if (user.phone.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.phone,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem('Cart Items', cartProvider.itemCount.toString()),
                      const SizedBox(width: 20),
                      _buildStatItem('Favorites', favoriteProducts.length.toString()),
                      const SizedBox(width: 20),
                      _buildStatItem('Orders', '12'), // Hardcoded for now
                    ],
                  ),
                ],
              ),
            ),

            // Account Section
            _buildMenuSection(
              'Account',
              [
                _buildMenuItem(
                  context,
                  Icons.person_outline,
                  'Personal Information',
                  Icons.chevron_right,
                  onTap: () => _showPersonalInfo(context, user),
                ),
                _buildMenuItem(
                  context,
                  Icons.location_on_outlined,
                  'Delivery Address',
                  Icons.chevron_right,
                  onTap: () => _showAddressDialog(context, user),
                ),
                _buildMenuItem(
                  context,
                  Icons.payment_outlined,
                  'Payment Methods',
                  Icons.chevron_right,
                  onTap: () => _showPaymentMethods(context),
                ),
              ],
            ),

            // Orders Section
            _buildMenuSection(
              'Orders',
              [
                _buildMenuItem(
                  context,
                  Icons.history_outlined,
                  'Order History',
                  Icons.chevron_right,
                  onTap: () => _showOrderHistory(context),
                ),
                _buildMenuItem(
                  context,
                  Icons.local_offer_outlined,
                  'Promotions',
                  Icons.chevron_right,
                  onTap: () => _showPromotions(context),
                ),
                _buildMenuItem(
                  context,
                  Icons.star_outline,
                  'My Reviews',
                  Icons.chevron_right,
                  onTap: () => _showMyReviews(context),
                ),
              ],
            ),

            // Favorites Section
            if (favoriteProducts.isNotEmpty) ...[
              _buildMenuSection(
                'Your Favorites',
                favoriteProducts.take(3).map((product) {
                  return _buildFavoriteItem(context, product);
                }).toList(),
              ),
            ],

            // Support Section
            _buildMenuSection(
              'Support',
              [
                _buildMenuItem(
                  context,
                  Icons.help_outline,
                  'Help Center',
                  Icons.chevron_right,
                  onTap: () => _showHelpCenter(context),
                ),
                _buildMenuItem(
                  context,
                  Icons.chat_outlined,
                  'Contact Us',
                  Icons.chevron_right,
                  onTap: () => _showContactUs(context),
                ),
                _buildMenuItem(
                  context,
                  Icons.privacy_tip_outlined,
                  'Privacy Policy',
                  Icons.chevron_right,
                  onTap: () => _showPrivacyPolicy(context),
                ),
                _buildMenuItem(
                  context,
                  Icons.description_outlined,
                  'Terms & Conditions',
                  Icons.chevron_right,
                  onTap: () => _showTermsAndConditions(context),
                ),
              ],
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.red[200]!),
                    ),
                  ),
                  onPressed: () {
                    _showLogoutDialog(context, authProvider);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_outlined),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // App Version
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Food Delivery App v1.0.0',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
      BuildContext context,
      IconData leadingIcon,
      String title,
      IconData trailingIcon, {
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                leadingIcon,
                color: Colors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              trailingIcon,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(BuildContext context, Product product) {
    return InkWell(
      onTap: () {
        // Navigate to product details
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber[400],
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
              onPressed: () {
                Provider.of<ProductProvider>(context, listen: false)
                    .toggleFavorite(product.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Dialog Methods
  void _showPersonalInfo(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Personal Information'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('Name', user.name),
              _buildInfoRow('Email', user.email),
              _buildInfoRow('Phone', user.phone),
              if (user.address != null) _buildInfoRow('Address', user.address!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // Edit personal info
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delivery Address'),
        content: Text(user.address ?? 'No address set'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // Add/edit address
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethods(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Methods'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Credit/Debit Card'),
              subtitle: Text('**** **** **** 1234'),
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Wallet'),
              subtitle: Text('\$50.00'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // Add payment method
            },
            child: const Text('Add New'),
          ),
        ],
      ),
    );
  }

  void _showOrderHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order History'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildOrderItem('#12345', 'Completed', '\$45.99', '2 items'),
              _buildOrderItem('#12344', 'Completed', '\$32.50', '3 items'),
              _buildOrderItem('#12343', 'Cancelled', '\$28.75', '2 items'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String orderId, String status, String amount, String items) {
    Color statusColor = status == 'Completed' ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderId,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                items,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Text(
                status,
                style: TextStyle(color: statusColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPromotions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Promotions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPromotionItem('WELCOME30', '30% off first order'),
            _buildPromotionItem('SAVE20', '\$20 off on orders above \$100'),
            _buildPromotionItem('FREEDEL', 'Free delivery this week'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionItem(String code, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(color: Colors.orange[800]),
            ),
          ),
        ],
      ),
    );
  }

  void _showMyReviews(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('My Reviews'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(child: Icon(Icons.restaurant)),
              title: Text('Margherita Pizza'),
              subtitle: Text('Great taste! Will order again.'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text('5.0'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help Center'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Frequently Asked Questions:'),
            SizedBox(height: 10),
            Text('• How do I track my order?'),
            Text('• How can I cancel my order?'),
            Text('• What payment methods are accepted?'),
            Text('• How do I contact customer support?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // Contact support
            },
            child: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }

  void _showContactUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Us'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: support@fooddelivery.com'),
            SizedBox(height: 8),
            Text('Phone: +1 (555) 123-4567'),
            SizedBox(height: 8),
            Text('Hours: 9AM - 9PM, 7 days a week'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: SingleChildScrollView(
            child: Text(
              'Your privacy is important to us. This privacy policy explains what personal data we collect and how we use it...\n\n'
                  '1. Information We Collect\n'
                  'We collect information you provide directly to us when using our services.\n\n'
                  '2. How We Use Your Information\n'
                  'We use the information to provide, maintain, and improve our services.\n\n'
                  '3. Information Sharing\n'
                  'We do not share your personal information with third parties except as described in this policy.',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: SingleChildScrollView(
            child: Text(
              'By using our services, you agree to these terms and conditions...\n\n'
                  '1. Service Usage\n'
                  'You agree to use our services only for lawful purposes.\n\n'
                  '2. Account Security\n'
                  'You are responsible for maintaining the confidentiality of your account.\n\n'
                  '3. Order Cancellation\n'
                  'Orders can be cancelled within 5 minutes of placing them.',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              authProvider.logout();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}