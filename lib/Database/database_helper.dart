import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const int _databaseVersion = 8; // Increased version to 8 for re-seeding

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'food_delivery.db');

      print('Database path: $path');

      // Check if database exists
      bool exists = await databaseExists(path);

      if (!exists) {
        // Make sure the directory exists
        try {
          await Directory(databasesPath).create(recursive: true);
        } catch (_) {}
      }

      // Open or create the database
      Database db = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: (db) {
          print('Database opened successfully. Version: $_databaseVersion');
        },
      );

      return db;
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<bool> databaseExists(String path) async {
    try {
      return await File(path).exists();
    } catch (_) {
      return false;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    print('Creating database tables for version $version...');
    await _createAllTables(db);
    await _insertSampleData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from version $oldVersion to $newVersion...');

    // Handle migrations based on version
    if (oldVersion < 2) {
      // Add users table if upgrading from version 1
      await _createUsersTable(db);
      await _insertSampleUser(db);
    }

    if (oldVersion < 8) {
      print('Dropping products table for re-seeding in version 8...');
      await db.execute('DROP TABLE IF EXISTS products');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS products(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          price REAL NOT NULL,
          imageUrl TEXT,
          category TEXT NOT NULL,
          rating REAL DEFAULT 0,
          isFavorite INTEGER DEFAULT 0,
          preparationTime TEXT
        )
      ''');
      await _insertSampleData(db);
    }
  }

  Future<void> _createAllTables(Database db) async {
    try {
      // Products table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS products(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          price REAL NOT NULL,
          imageUrl TEXT,
          category TEXT NOT NULL,
          rating REAL DEFAULT 0,
          isFavorite INTEGER DEFAULT 0,
          preparationTime TEXT
        )
      ''');

      // Cart items table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS cart_items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          productId INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          addedAt TEXT NOT NULL,
          FOREIGN KEY (productId) REFERENCES products (id)
        )
      ''');

      // Users table (NEW)
      await _createUsersTable(db);

      print('All tables created successfully');

    } catch (e) {
      print('Error creating tables: $e');
      rethrow;
    }
  }

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT NOT NULL,
        password TEXT NOT NULL,
        address TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
    print('Users table created or already exists');
  }

  Future<void> _insertSampleData(Database db) async {
    try {
      // Check if products already exist
      List<Map> existingProducts = await db.query('products');

      if (existingProducts.isEmpty) {
        print('Inserting sample products...');

        // Sample products
        List<Map<String, dynamic>> products = [
          {
            'name': 'Margherita Pizza',
            'description': 'Classic pizza with tomato sauce and mozzarella cheese',
            'price': 12.99,
            'imageUrl': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&fit=crop',
            'category': 'Italian',
            'rating': 4.5,
            'isFavorite': 1,
            'preparationTime': '20-25 min'
          },
          {
            'name': 'Cheeseburger',
            'description': 'Beef patty with cheese, lettuce, and special sauce',
            'price': 9.99,
            'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&fit=crop',
            'category': 'Fast Food',
            'rating': 4.3,
            'isFavorite': 0,
            'preparationTime': '15-20 min'
          },
          {
            'name': 'Caesar Salad',
            'description': 'Fresh romaine lettuce with Caesar dressing and croutons',
            'price': 8.99,
            'imageUrl': 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&fit=crop',
            'category': 'Salads',
            'rating': 4.2,
            'isFavorite': 1,
            'preparationTime': '10-15 min'
          },
          {
            'name': 'Sushi Platter',
            'description': 'Assorted sushi with salmon, tuna, and avocado',
            'price': 18.99,
            'imageUrl': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&fit=crop',
            'category': 'Japanese',
            'rating': 4.7,
            'isFavorite': 0,
            'preparationTime': '25-30 min'
          },
          {
            'name': 'Chocolate Lava Cake',
            'description': 'Warm chocolate cake with molten center and ice cream',
            'price': 6.99,
            'imageUrl': 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&fit=crop',
            'category': 'Desserts',
            'rating': 4.8,
            'isFavorite': 1,
            'preparationTime': '10-12 min'
          },
          {
            'name': 'Chicken Biryani',
            'description': 'Fragrant rice with spiced chicken and herbs',
            'price': 14.99,
            'imageUrl': 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?w=400&fit=crop',
            'category': 'Indian',
            'rating': 4.6,
            'isFavorite': 0,
            'preparationTime': '30-35 min'
          },

          // New 10 products
          {
            'name': 'Spicy Chicken Wings',
            'description': 'Crispy chicken wings tossed in spicy buffalo sauce, served with ranch dip',
            'price': 11.99,
            'imageUrl': 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=400&fit=crop',
            'category': 'Appetizers',
            'rating': 4.4,
            'isFavorite': 0,
            'preparationTime': '15-20 min'
          },
          {
            'name': 'Beef Tacos (3 Pieces)',
            'description': 'Soft corn tortillas filled with seasoned ground beef, lettuce, cheese, and salsa',
            'price': 10.99,
            'imageUrl': 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&fit=crop',
            'category': 'Mexican',
            'rating': 4.6,
            'isFavorite': 1,
            'preparationTime': '12-15 min'
          },
          {
            'name': 'Vegetable Stir Fry',
            'description': 'Fresh mixed vegetables stir-fried in soy-ginger sauce with tofu, served with jasmine rice',
            'price': 13.49,
            'imageUrl': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&fit=crop',
            'category': 'Vegetarian',
            'rating': 4.3,
            'isFavorite': 0,
            'preparationTime': '18-22 min'
          },
          {
            'name': 'Grilled Salmon Steak',
            'description': 'Atlantic salmon fillet grilled with lemon herb butter, served with roasted vegetables',
            'price': 21.99,
            'imageUrl': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&fit=crop',
            'category': 'Seafood',
            'rating': 4.8,
            'isFavorite': 1,
            'preparationTime': '20-25 min'
          },
          {
            'name': 'BBQ Chicken Pizza',
            'description': 'Thin crust pizza with BBQ sauce, grilled chicken, red onions, and mozzarella cheese',
            'price': 16.99,
            'imageUrl': 'https://images.unsplash.com/photo-1595708684082-a173bb3a06c5?w=400&fit=crop',
            'category': 'Italian',
            'rating': 4.7,
            'isFavorite': 1,
            'preparationTime': '22-27 min'
          },
          {
            'name': 'Classic Beef Steak',
            'description': '8oz ribeye steak cooked to perfection, served with garlic mashed potatoes and asparagus',
            'price': 24.99,
            'imageUrl': 'https://images.unsplash.com/photo-1600891964092-4316c288032e?w=400&fit=crop',
            'category': 'Steakhouse',
            'rating': 4.9,
            'isFavorite': 0,
            'preparationTime': '25-30 min'
          },
          {
            'name': 'Chicken Shawarma Plate',
            'description': 'Marinated chicken served with rice, hummus, tabbouleh, pita bread, and garlic sauce',
            'price': 14.99,
            'imageUrl': 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400&fit=crop',
            'category': 'Middle Eastern',
            'rating': 4.5,
            'isFavorite': 0,
            'preparationTime': '15-18 min'
          },
          {
            'name': 'Mango Lassi',
            'description': 'Refreshing yogurt-based drink blended with sweet mango pulp and cardamom',
            'price': 4.99,
            'imageUrl': 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=400&fit=crop',
            'category': 'Beverages',
            'rating': 4.2,
            'isFavorite': 1,
            'preparationTime': '5-8 min'
          },
          {
            'name': 'Cheese Garlic Bread',
            'description': 'Freshly baked bread topped with garlic butter and melted mozzarella cheese',
            'price': 7.99,
            'imageUrl': 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=400&fit=crop',
            'category': 'Sides',
            'rating': 4.1,
            'isFavorite': 0,
            'preparationTime': '8-12 min'
          },
          {
            'name': 'Tiramisu Dessert',
            'description': 'Classic Italian dessert with layers of coffee-soaked ladyfingers and mascarpone cream',
            'price': 8.99,
            'imageUrl': 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400&fit=crop',
            'category': 'Desserts',
            'rating': 4.9,
            'isFavorite': 1,
            'preparationTime': '10-15 min'
          },
          // Chinese
          {
            'name': 'Kung Pao Chicken',
            'description': 'Spicy stir-fried chicken with peanuts, bell peppers, and chili peppers',
            'price': 13.99,
            'imageUrl': 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=400&fit=crop',
            'category': 'Chinese',
            'rating': 4.6,
            'isFavorite': 0,
            'preparationTime': '15-20 min'
          },
          {
            'name': 'Steamed Dim Sum Platter',
            'description': 'Assorted steamed dumplings filled with minced prawn and chicken',
            'price': 15.99,
            'imageUrl': 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=400&fit=crop',
            'category': 'Chinese',
            'rating': 4.8,
            'isFavorite': 1,
            'preparationTime': '20-25 min'
          },
          // Continental
          {
            'name': 'Pasta Carbonara',
            'description': 'Spaghetti tossed with bacon, egg yolks, black pepper, and cheese',
            'price': 14.49,
            'imageUrl': 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400&fit=crop',
            'category': 'Continental',
            'rating': 4.5,
            'isFavorite': 1,
            'preparationTime': '15-18 min'
          },
          {
            'name': 'Shepherd\'s Pie',
            'description': 'Traditional English pie with minced meat topped with mashed potatoes and cheese crust',
            'price': 16.99,
            'imageUrl': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=400&fit=crop',
            'category': 'Continental',
            'rating': 4.7,
            'isFavorite': 0,
            'preparationTime': '25-30 min'
          },
          // Breakfast
          {
            'name': 'Buttermilk Pancakes',
            'description': 'Fluffy pancakes stacked high, served with fresh berries, maple syrup, and whipped butter',
            'price': 9.49,
            'imageUrl': 'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=400&fit=crop',
            'category': 'Breakfast',
            'rating': 4.6,
            'isFavorite': 1,
            'preparationTime': '10-12 min'
          },
          {
            'name': 'Classic Avocado Toast',
            'description': 'Toasted sourdough bread topped with mashed avocado, cherry tomatoes, and poached eggs',
            'price': 10.99,
            'imageUrl': 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&fit=crop',
            'category': 'Breakfast',
            'rating': 4.4,
            'isFavorite': 0,
            'preparationTime': '8-10 min'
          },
          // Bakery
          {
            'name': 'Chocolate Croissant',
            'description': 'Flaky, buttery French pastry filled with rich dark chocolate, baked fresh daily',
            'price': 4.49,
            'imageUrl': 'https://images.unsplash.com/photo-1549931319-a545dcf3bc73?w=400&fit=crop',
            'category': 'Bakery',
            'rating': 4.7,
            'isFavorite': 1,
            'preparationTime': '5 min'
          },
          {
            'name': 'Blueberry Muffin',
            'description': 'Sweet baked muffin bursting with fresh blueberries, topped with crumbly streusel',
            'price': 3.99,
            'imageUrl': 'https://images.unsplash.com/photo-1607958996333-41aef7caefaa?w=400&fit=crop',
            'category': 'Bakery',
            'rating': 4.5,
            'isFavorite': 0,
            'preparationTime': '5 min'
          },
          // New 26 products to reach 50 in total
          {
            'name': 'Pepperoni Pizza',
            'description': 'Freshly baked crust loaded with double pepperoni and melted mozzarella cheese',
            'price': 14.99,
            'imageUrl': 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400&fit=crop',
            'category': 'Italian',
            'rating': 4.7,
            'isFavorite': 0,
            'preparationTime': '20-25 min'
          },
          {
            'name': 'Garlic Parmesan Fries',
            'description': 'Crispy golden French fries tossed in garlic butter, fresh parsley, and parmesan cheese',
            'price': 6.49,
            'imageUrl': 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400&fit=crop',
            'category': 'Sides',
            'rating': 4.5,
            'isFavorite': 0,
            'preparationTime': '10-15 min'
          },
          {
            'name': 'Grilled Chicken Caesar Wrap',
            'description': 'Grilled chicken breast with romaine lettuce, parmesan cheese, and Caesar dressing in a soft tortilla wrap',
            'price': 10.99,
            'imageUrl': 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&fit=crop',
            'category': 'Fast Food',
            'rating': 4.4,
            'isFavorite': 1,
            'preparationTime': '12-15 min'
          },
          {
            'name': 'California Roll Sushi',
            'description': 'Delicious sushi roll containing crab stick, cucumber, avocado, and sesame seeds',
            'price': 12.99,
            'imageUrl': 'https://images.unsplash.com/photo-1553621042-f6e147245754?w=400&fit=crop',
            'category': 'Japanese',
            'rating': 4.5,
            'isFavorite': 0,
            'preparationTime': '20-25 min'
          },
          {
            'name': 'New York Cheesecake',
            'description': 'Rich and creamy New York-style baked cheesecake on a sweet graham cracker crust',
            'price': 7.49,
            'imageUrl': 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=400&fit=crop',
            'category': 'Desserts',
            'rating': 4.7,
            'isFavorite': 1,
            'preparationTime': '10 min'
          },
          {
            'name': 'Butter Chicken with Naan',
            'description': 'Tender chicken pieces cooked in a rich, spiced tomato and butter gravy, served with fresh garlic naan',
            'price': 16.49,
            'imageUrl': 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=400&fit=crop',
            'category': 'Indian',
            'rating': 4.8,
            'isFavorite': 1,
            'preparationTime': '25-30 min'
          },
          {
            'name': 'Crispy Onion Rings',
            'description': 'Thick-cut onion rings battered and fried to golden perfection, served with sweet chili dip',
            'price': 5.99,
            'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&fit=crop',
            'category': 'Appetizers',
            'rating': 4.3,
            'isFavorite': 0,
            'preparationTime': '10-12 min'
          },
          {
            'name': 'Chicken Quesadilla',
            'description': 'Grilled flour tortilla loaded with shredded chicken, peppers, onions, and melted Monterey Jack cheese',
            'price': 11.49,
            'imageUrl': 'https://images.unsplash.com/photo-1618449840665-9ed506d73a34?w=400&fit=crop',
            'category': 'Mexican',
            'rating': 4.5,
            'isFavorite': 0,
            'preparationTime': '12-15 min'
          },
          {
            'name': 'Tandoori Paneer Tikka',
            'description': 'Spiced Indian cheese chunks marinated in yogurt and grilled with bell peppers and onions in tandoor',
            'price': 12.99,
            'imageUrl': 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=400&fit=crop',
            'category': 'Vegetarian',
            'rating': 4.6,
            'isFavorite': 0,
            'preparationTime': '18-20 min'
          },
          {
            'name': 'Classic Fish and Chips',
            'description': 'Crispy beer-battered cod served with rustic French fries and tartar dipping sauce',
            'price': 15.99,
            'imageUrl': 'https://images.unsplash.com/photo-1534080564583-6be75777b70a?w=400&fit=crop',
            'category': 'Seafood',
            'rating': 4.6,
            'isFavorite': 1,
            'preparationTime': '15-20 min'
          },
          {
            'name': 'Ribeye Steak (10oz)',
            'description': 'Tender ribeye steak cooked to your liking, served with garlic herb butter and baby potatoes',
            'price': 26.99,
            'imageUrl': 'https://images.unsplash.com/photo-1546964124-0cce460f38ef?w=400&fit=crop',
            'category': 'Steakhouse',
            'rating': 4.9,
            'isFavorite': 0,
            'preparationTime': '25-30 min'
          },
          {
            'name': 'Falafel Wrap',
            'description': 'Crispy deep-fried chickpea balls with lettuce, tomato, pickles, and tahini sauce in a soft pita',
            'price': 9.49,
            'imageUrl': 'https://images.unsplash.com/photo-1561043433-aaf687c4cf04?w=400&fit=crop',
            'category': 'Middle Eastern',
            'rating': 4.4,
            'isFavorite': 0,
            'preparationTime': '12-15 min'
          },
          {
            'name': 'Iced Caramel Macchiato',
            'description': 'Espresso combined with vanilla-flavored syrup, milk, ice, and dynamic caramel drizzle',
            'price': 5.49,
            'imageUrl': 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=400&fit=crop',
            'category': 'Beverages',
            'rating': 4.5,
            'isFavorite': 0,
            'preparationTime': '5 min'
          },
          {
            'name': 'Greek Salad',
            'description': 'Traditional salad with tomatoes, cucumbers, olives, feta cheese, and olive oil dressing',
            'price': 9.99,
            'imageUrl': 'https://images.unsplash.com/photo-1505576399279-565b52d4ac71?w=400&fit=crop',
            'category': 'Salads',
            'rating': 4.4,
            'isFavorite': 0,
            'preparationTime': '8-10 min'
          },
          {
            'name': 'Sweet and Sour Chicken',
            'description': 'Crispy tempura chicken pieces tossed with pineapples, bell peppers, and tangy sweet & sour sauce',
            'price': 13.99,
            'imageUrl': 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=400&fit=crop',
            'category': 'Chinese',
            'rating': 4.6,
            'isFavorite': 1,
            'preparationTime': '15-20 min'
          },
          {
            'name': 'Baked Beef Lasagna',
            'description': 'Layers of flat pasta filled with seasoned minced beef, bolognese sauce, bechamel, and melted cheese',
            'price': 15.49,
            'imageUrl': 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?w=400&fit=crop',
            'category': 'Continental',
            'rating': 4.7,
            'isFavorite': 1,
            'preparationTime': '20-25 min'
          },
          {
            'name': 'Fluffy French Toast',
            'description': 'Thick slices of brioche bread dipped in sweet egg batter, grilled and dusted with cinnamon sugar',
            'price': 10.49,
            'imageUrl': 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=400&fit=crop',
            'category': 'Breakfast',
            'rating': 4.5,
            'isFavorite': 0,
            'preparationTime': '10-12 min'
          },
          {
            'name': 'Fresh Cinnamon Roll',
            'description': 'Warm, freshly baked pastry roll loaded with aromatic cinnamon and topped with sweet cream cheese glaze',
            'price': 4.99,
            'imageUrl': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&fit=crop',
            'category': 'Bakery',
            'rating': 4.7,
            'isFavorite': 1,
            'preparationTime': '5 min'
          },
          {
            'name': 'Gourmet Mac and Cheese',
            'description': 'Elbow macaroni baked in a rich four-cheese sauce, topped with toasted garlic breadcrumbs',
            'price': 8.99,
            'imageUrl': 'https://images.unsplash.com/photo-1608897013039-887f21d8c804?w=400&fit=crop',
            'category': 'Sides',
            'rating': 4.4,
            'isFavorite': 0,
            'preparationTime': '12-15 min'
          },
          {
            'name': 'Mozzarella Cheese Sticks',
            'description': 'Battered and deep-fried mozzarella sticks, served hot with rich marinara dipping sauce',
            'price': 6.99,
            'imageUrl': 'https://images.unsplash.com/photo-1548340748-6d2b7d7da280?w=400&fit=crop',
            'category': 'Appetizers',
            'rating': 4.2,
            'isFavorite': 0,
            'preparationTime': '8-10 min'
          },
          {
            'name': 'Shrimp Tempura (5 Pieces)',
            'description': 'Jumbo shrimp battered in light Japanese tempura flour and fried, served with tentsuyu sauce',
            'price': 14.99,
            'imageUrl': 'https://images.unsplash.com/photo-1563612116625-3012372fccce?w=400&fit=crop',
            'category': 'Seafood',
            'rating': 4.7,
            'isFavorite': 0,
            'preparationTime': '12-15 min'
          },
          {
            'name': 'Cheese Beef Enchiladas',
            'description': 'Seasoned ground beef wrapped in corn tortillas, covered in red chili sauce and baked cheese',
            'price': 13.99,
            'imageUrl': 'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=400&fit=crop',
            'category': 'Mexican',
            'rating': 4.6,
            'isFavorite': 1,
            'preparationTime': '18-22 min'
          },
          {
            'name': 'Chicken Fried Rice',
            'description': 'Stir-fried jasmine rice with tender chicken breast, eggs, peas, carrots, and savory soy sauce',
            'price': 11.99,
            'imageUrl': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&fit=crop',
            'category': 'Chinese',
            'rating': 4.5,
            'isFavorite': 0,
            'preparationTime': '12-15 min'
          },
          {
            'name': 'Giant Chocolate Chip Cookie',
            'description': 'Crispy on the edges, chewy in the center, and loaded with melted chocolate chunks',
            'price': 3.49,
            'imageUrl': 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=400&fit=crop',
            'category': 'Bakery',
            'rating': 4.6,
            'isFavorite': 0,
            'preparationTime': '5 min'
          },
          {
            'name': 'Traditional Apple Pie',
            'description': 'Warm spiced apple filling encased in a golden flaky pastry crust, served by the slice',
            'price': 6.49,
            'imageUrl': 'https://images.unsplash.com/photo-1519869325930-281384150729?w=400&fit=crop',
            'category': 'Desserts',
            'rating': 4.8,
            'isFavorite': 1,
            'preparationTime': '10 min'
          },
          {
            'name': 'Caprese Salad',
            'description': 'Slices of fresh mozzarella, vine-ripened tomatoes, and fresh basil leaves drizzled with balsamic glaze',
            'price': 9.49,
            'imageUrl': 'https://images.unsplash.com/photo-1529566652340-2c41a1eb6d93?w=400&fit=crop',
            'category': 'Salads',
            'rating': 4.5,
            'isFavorite': 0,
            'preparationTime': '8-10 min'
          },
        ];

        for (var product in products) {
          await db.insert('products', product);
        }

        print('Sample products inserted successfully. ${products.length} products added.');
      } else {
        print('Products already exist. Skipping insertion.');
      }

      // Insert sample user
      await _insertSampleUser(db);

    } catch (e) {
      print('Error inserting sample data: $e');
    }
  }

  Future<void> _insertSampleUser(Database db) async {
    try {
      // Check if users already exist
      List<Map> existingUsers = await db.query('users');

      if (existingUsers.isEmpty) {
        print('Inserting sample user...');

        // Insert a sample user (for testing)
        await db.insert('users', {
          'name': 'John Doe',
          'email': 'john@example.com',
          'phone': '+1234567890',
          'password': 'password123', // In real app, use encryption
          'address': '123 Main St, City',
          'createdAt': DateTime.now().toIso8601String(),
        });

        print('Sample user inserted successfully');
      } else {
        print('Users already exist. Skipping insertion.');
      }
    } catch (e) {
      print('Error inserting sample user: $e');
    }
  }

  // For debugging: Get all tables info
  Future<void> printDatabaseInfo() async {
    try {
      final db = await database;

      // Check what tables exist
      List<Map> tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table'"
      );

      print('\n=== DATABASE INFO ===');
      print('Tables in database:');
      for (var table in tables) {
        print('- ${table['name']}');
      }

      // Check users table
      try {
        List<Map> users = await db.query('users');
        print('\nUsers table has ${users.length} records');
        for (var user in users) {
          print('User: ${user['name']} (${user['email']})');
        }
      } catch (e) {
        print('Error checking users table: $e');
      }

      print('=====================\n');
    } catch (e) {
      print('Error getting database info: $e');
    }
  }

  // Delete database for testing
  Future<void> deleteDatabaseFile() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'food_delivery.db');

    if (await databaseExists(path)) {
      await deleteDatabase(path);
      _database = null;
      print('Database file deleted');
    }
  }

  // Reset database (for debugging)
  Future<void> resetDatabase() async {
    await deleteDatabaseFile();
    _database = null;
    await database; // This will recreate the database
  }
}