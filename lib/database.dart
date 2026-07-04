import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE basket(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(255), price DOUBLE)",
        );
      },
      version: 1,
    );
  }

  Future<int> createItem(BasketDB basket) async {
    final db = await initDB();
    final id = await db.insert(
      'basket',
      basket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<BasketDB>> getItems() async {
    final db = await initDB();
    final List<Map<String, dynamic>> items = await db.query('basket');
    return items.map((item) => BasketDB.fromMap(item)).toList();
  }

  Future deleteItem(int id) async {
    final db = await initDB();
    try {
      await db.delete("basket", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("$err");
    }
  }

  Future<double> totalPrice() async {
    final db = await initDB();
    final List<Map<String, dynamic>> total = await db.rawQuery(
      'SELECT SUM(price) FROM BASKET',
    );
    final sum = total.first['SUM(price)'];
    return sum;
  }
}

class BasketDB {
  final int? id;
  final String name;
  final double price;

  BasketDB({this.id, required this.name, required this.price});
  BasketDB.fromMap(Map<String, dynamic> item)
    : id = item["id"],
      name = item["name"],
      price = (item["price"] as num).toDouble();

  Map<String, Object> toMap() {
    return {'name': name, 'price': price};
  }
}
