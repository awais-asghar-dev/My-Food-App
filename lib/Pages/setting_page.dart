import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSection(
              'Notifications',
              [
                _buildSettingItem(
                  'Push Notifications',
                  'Receive order updates',
                  Switch(value: true, onChanged: (value) {}),
                ),
                _buildSettingItem(
                  'Email Notifications',
                  'Get promotional emails',
                  Switch(value: true, onChanged: (value) {}),
                ),
                _buildSettingItem(
                  'SMS Alerts',
                  'Order status via SMS',
                  Switch(value: false, onChanged: (value) {}),
                ),
              ],
            ),
            _buildSection(
              'Preferences',
              [
                _buildSettingItem(
                  'Language',
                  'English',
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ),
                _buildSettingItem(
                  'Currency',
                  'USD (\$)',
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ),
                _buildSettingItem(
                  'Theme',
                  'Light Mode',
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ),
              ],
            ),
            _buildSection(
              'Privacy',
              [
                _buildSettingItem(
                  'Location Services',
                  'Always',
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ),
                _buildSettingItem(
                  'Data Usage',
                  'Optimized',
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ),
                _buildSettingItem(
                  'Clear Cache',
                  '24.5 MB',
                  TextButton(
                    onPressed: () {},
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
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

  Widget _buildSettingItem(String title, String subtitle, Widget trailing) {
    return Container(
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
                const SizedBox(height: 4),
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
          trailing,
        ],
      ),
    );
  }
}