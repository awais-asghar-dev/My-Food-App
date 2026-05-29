import 'package:flutter/material.dart';
import 'package:my_food_app/Database/database_helper.dart';

class DatabaseInitializer extends StatefulWidget {
  final Widget child;

  const DatabaseInitializer({Key? key, required this.child}) : super(key: key);

  @override
  State<DatabaseInitializer> createState() => _DatabaseInitializerState();
}

class _DatabaseInitializerState extends State<DatabaseInitializer> {
  bool _initialized = false;
  bool _error = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      print('Initializing database...');

      // Initialize the database
      final dbHelper = DatabaseHelper();
      await dbHelper.database;

      print('Database initialized successfully');

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print('Error initializing database: $e');
      setState(() {
        _error = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                'Database Initialization Failed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  _errorMessage ?? 'Unknown error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initializeDatabase,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_initialized) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Initializing database...'),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}