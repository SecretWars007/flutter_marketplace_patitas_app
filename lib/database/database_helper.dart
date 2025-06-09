import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user_model.dart';
import '../models/role_model.dart';
import '../models/profile_model.dart';
import '../models/product_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static DatabaseHelper get instance => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bd_patitas.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE roles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      );
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role_id INTEGER NOT NULL,
        FOREIGN KEY(role_id) REFERENCES roles(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE profiles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL UNIQUE,
        name TEXT,
        phone TEXT,
        photo TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        image TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id)
      );
    ''');

    // Insertar roles iniciales
    await db.insert('roles', {'name': 'COMPRADOR'});
    await db.insert('roles', {'name': 'VENDEDOR'});
  }

  // ----- Roles -----

  Future<List<Role>> getAllRoles() async {
    final db = await database;
    final maps = await db.query('roles');
    return List.generate(maps.length, (i) => Role.fromMap(maps[i]));
  }

  Future<Role?> getRoleByName(String name) async {
    final db = await database;
    final maps = await db.query('roles', where: 'name = ?', whereArgs: [name]);
    if (maps.isEmpty) return null;
    return Role.fromMap(maps.first);
  }

  // ----- Users -----

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  // ----- Profiles -----

  Future<int> insertProfile(Profile profile) async {
    final db = await database;
    return await db.insert('profiles', profile.toMap());
  }

  Future<int> updateProfile(Profile profile) async {
    final db = await database;
    return await db.update(
      'profiles',
      profile.toMap(),
      where: 'user_id = ?',
      whereArgs: [profile.userId],
    );
  }

  Future<Profile?> getProfileByUserId(int userId) async {
    final db = await database;
    final maps = await db.query(
      'profiles',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    if (maps.isEmpty) return null;
    return Profile.fromMap(maps.first);
  }

  // ----- Products -----

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Product>> getProductsByUserId(int userId) async {
    final db = await database;
    final maps = await db.query(
      'products',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }
}
