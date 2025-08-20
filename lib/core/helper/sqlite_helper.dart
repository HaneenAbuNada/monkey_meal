import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../src/model/item_model.dart';
import '../../src/model/order_model.dart';
import '../../src/model/payment_model.dart';
import '../../src/model/user_model.dart';

class SqliteHelper {
  static const _databaseName = 'monkey_meal.db';
  static const _databaseVersion = 1;

  static SqliteHelper? _instance;
  static Database? _database;

  SqliteHelper._privateConstructor();

  factory SqliteHelper() {
    _instance ??= SqliteHelper._privateConstructor();
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT,
      phone TEXT,
      address TEXT,
      token TEXT,
      imageUrl TEXT,
      createdAt INTEGER NOT NULL,
      updatedAt INTEGER
    )
  ''');

    await db.execute('''
      CREATE TABLE items (
        itemName TEXT PRIMARY KEY,
        itemDescription TEXT NOT NULL,
        itemCover TEXT NOT NULL,
        itemRating REAL NOT NULL,
        itemPrice REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        itemName TEXT NOT NULL,
        itemDescription TEXT NOT NULL,
        itemCover TEXT NOT NULL,
        itemRating REAL NOT NULL,
        itemPrice REAL NOT NULL,
        quantity INTEGER NOT NULL,
        orderedAt INTEGER NOT NULL,
        status TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE payments (
        id TEXT PRIMARY KEY,
        cardNumber TEXT NOT NULL,
        cardHolderName TEXT NOT NULL,
        expiryDate TEXT NOT NULL,
        cvv TEXT NOT NULL,
        isDefault INTEGER NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        userId TEXT NOT NULL,
        itemName TEXT NOT NULL,
        PRIMARY KEY (userId, itemName)
      )
    ''');
  }

  // Future<int> insertUser(UserModel user) async {
  //   final db = await database;
  //   return await db.insert('users', user.toFirestoreJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  Future<UserModel?> getUser(String id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first, id);
    }
    return null;
  }

  // Future<int> updateUser(UserModel user) async {
  //   final db = await database;
  //   return await db.update('users', user.toFirestoreJson(), where: 'id = ?', whereArgs: [user.id]);
  // }

  Future<int> deleteUser(String id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertItem(ItemModel item) async {
    final db = await database;
    return await db.insert('items', item.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ItemModel>> getAllItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) => ItemModel.fromMap(maps[i]));
  }

  Future<ItemModel?> getItem(String itemName) async {
    final db = await database;
    final maps = await db.query('items', where: 'itemName = ?', whereArgs: [itemName]);

    if (maps.isNotEmpty) {
      return ItemModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteItem(String itemName) async {
    final db = await database;
    return await db.delete('items', where: 'itemName = ?', whereArgs: [itemName]);
  }

  Future<int> insertOrder(OrderModel order) async {
    final db = await database;
    return await db.insert('orders', {
      'id': order.id,
      'itemName': order.itemName,
      'itemDescription': order.itemDescription,
      'itemCover': order.itemCover,
      'itemRating': order.itemRating,
      'itemPrice': order.itemPrice,
      'quantity': order.quantity,
      'orderedAt': order.orderedAt.millisecondsSinceEpoch,
      'status': order.status,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<OrderModel>> getAllOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('orders');
    return List.generate(maps.length, (i) {
      final data = maps[i];
      return OrderModel(
        id: data['id']?.toString() ?? '',
        // معالجة القيم الفارغة
        itemName: data['itemName']?.toString() ?? '',
        itemDescription: data['itemDescription']?.toString() ?? '',
        itemCover: data['itemCover']?.toString() ?? '',
        itemRating: (data['itemRating'] as num?)?.toDouble() ?? 0.0,
        itemPrice: (data['itemPrice'] as num?)?.toDouble() ?? 0.0,
        quantity: (data['quantity'] as int?) ?? 1,
        orderedAt: DateTime.fromMillisecondsSinceEpoch(data['orderedAt'] as int? ?? 0),
        status: data['status']?.toString() ?? 'pending',
      );
    });
  }

  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    final db = await database;
    final maps = await db.query('orders', where: 'status = ?', whereArgs: [status]);
    return List.generate(maps.length, (i) {
      return OrderModel.fromFirestore(maps[i]['id'] as String, maps[i]);
    });
  }

  Future<int> updateOrderStatus(String orderId, String status) async {
    final db = await database;
    return await db.update('orders', {'status': status}, where: 'id = ?', whereArgs: [orderId]);
  }

  Future<int> deleteOrder(String orderId) async {
    final db = await database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [orderId]);
  }

  Future<int> insertPayment(PaymentModel payment) async {
    final db = await database;
    return await db.insert('payments', {
      'id': payment.id,
      'cardNumber': payment.cardNumber,
      'cardHolderName': payment.cardHolderName,
      'expiryDate': payment.expiryDate,
      'cvv': payment.cvv,
      'isDefault': payment.isDefault ? 1 : 0,
      'createdAt': payment.createdAt.millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PaymentModel>> getAllPayments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('payments');
    return List.generate(maps.length, (i) {
      final data = maps[i];
      return PaymentModel(
        id: data['id']?.toString() ?? '',
        cardNumber: data['cardNumber']?.toString() ?? '',
        cardHolderName: data['cardHolderName']?.toString() ?? '',
        expiryDate: data['expiryDate']?.toString() ?? '',
        cvv: data['cvv']?.toString() ?? '',
        isDefault: data['isDefault'] == 1,
        createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int? ?? 0),
      );
    });
  }

  Future<int> setDefaultPayment(String paymentId) async {
    final db = await database;
    await db.update('payments', {'isDefault': 0});
    return await db.update('payments', {'isDefault': 1}, where: 'id = ?', whereArgs: [paymentId]);
  }

  Future<int> deletePayment(String paymentId) async {
    final db = await database;
    return await db.delete('payments', where: 'id = ?', whereArgs: [paymentId]);
  }

  Future<int> addFavorite(String userId, String itemName) async {
    final db = await database;
    return await db.insert('favorites', {'userId': userId, 'itemName': itemName});
  }

  Future<int> removeFavorite(String userId, String itemName) async {
    final db = await database;
    return await db.delete('favorites', where: 'userId = ? AND itemName = ?', whereArgs: [userId, itemName]);
  }

  Future<bool> isFavorite(String userId, String itemName) async {
    final db = await database;
    final maps = await db.query('favorites', where: 'userId = ? AND itemName = ?', whereArgs: [userId, itemName]);
    return maps.isNotEmpty;
  }

  Future<List<String>> getUserFavorites(String userId) async {
    final db = await database;
    final maps = await db.query('favorites', where: 'userId = ?', whereArgs: [userId]);
    return maps.map((map) => map['itemName'] as String).toList();
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('users');
    await db.delete('items');
    await db.delete('orders');
    await db.delete('payments');
    await db.delete('favorites');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
