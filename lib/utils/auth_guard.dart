import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_food_app/Providers/auth_provider.dart';
import 'package:my_food_app/Pages/auth/login_page.dart';

class AuthGuard {
  static Future<bool> requireAuth(
      BuildContext context, {
        required VoidCallback onAuthenticated,
        bool showLoginPage = true,
      }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isLoggedIn) {
      onAuthenticated();
      return true;
    } else {
      if (showLoginPage) {
        await _showAuthDialog(context, onAuthenticated);
      }
      return false;
    }
  }

  static Future<void> _showAuthDialog(
      BuildContext context,
      VoidCallback onAuthenticated,
      ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: LoginPage(
          onLoginSuccess: onAuthenticated,
        ),
      ),
    );
  }
}