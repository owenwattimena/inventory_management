import 'package:sqflite/sqflite.dart';

import '../models/product.dart';
import 'database_service.dart';

class ProductService {
  late DatabaseService database;

  ProductService() {
    database = DatabaseService();
  }

  Future<List<Map<String, Object?>>> getCategory({String? query}) async {
    final db = await database.database;
    if (query == null) {
      return await db.rawQuery('SELECT DISTINCT category FROM product');
    } else {
      var sql = '''
      SELECT DISTINCT category FROM product WHERE category LIKE '%$query%'
    ''';
      return await db.rawQuery(sql);
    }
  }

  Future<List<Map<String, Object?>>> getUom(String query) async {
    final db = await database.database;
    var sql = '''
    SELECT DISTINCT uom FROM product WHERE uom LIKE '%$query%'
    ''';
    final mapObject = await db.rawQuery(sql);
    return mapObject;
  }

  Future<bool> addProduct(Product product) async {
    final db = await database.database;
    var sql = '''SELECT sku, barcode FROM product WHERE sku = ?''';
    // '''SELECT sku, barcode FROM product WHERE sku = ? OR barcode = ?''';
    var data = await db.rawQuery(sql, [product.sku]);
    if (data.isEmpty) {
      sql = '''
    INSERT INTO product (id, sku, barcode, name, category, uom, price) VALUES (?, ?, ?, ?, ?, ?, ?)
    ''';
      var result = await db.rawInsert(sql, [
        null,
        product.sku,
        product.barcode,
        product.name,
        product.category,
        product.uom,
        product.price
      ]);
      return result > 0;
    }
    return false;
  }

  Future<List<Map<String, Object?>>> getProduct(
      {String? query, String? category}) async {
    Database db = await database.database;
    List<Map<String, Object?>> mapObject;
    List<dynamic> whereArgs;
    if (query == null) {
      if (category == null) {
        var sql = '''
        SELECT * FROM product
        ''';
        mapObject = await db.rawQuery(sql);
      } else {
        var sql = '''
        SELECT * FROM product WHERE category = ?
        ''';
        whereArgs = [category];
        mapObject = await db.rawQuery(sql, whereArgs);
      }
    } else {
      var sql =
          'SELECT * FROM product WHERE name LIKE "%$query%" OR sku LIKE "%$query%" OR barcode LIKE "%$query%"';
      mapObject = await db.rawQuery(sql);
    }
    return mapObject;
  }

  Future<Map<String, Object?>?> getLastProductTransaction(String sku) async {
    Database db = await database.database;
    var sql = '''
    SELECT 
    product_transaction.created_at, 
    product_transaction.transaction_id, 
    transaction_detail.sku, 
    transaction_detail.last_stock, 
    transaction_detail.quantity,
    transaction_detail.stock 
    FROM transaction_detail 
    JOIN product_transaction
    ON transaction_detail.transaction_id = product_transaction.transaction_id 
    WHERE transaction_detail.sku = ? 
    AND product_transaction.status = ? 
    ORDER BY product_transaction.created_at DESC 
    LIMIT 1
  ''';
    List<Map<String, Object?>> data = await db.rawQuery(sql, [sku, "finished"]);
    if (data.isEmpty) return null;
    return data[0];
  }

  Future<bool> storeProduct(Product product) async {
    Database db = await database.database;
    List<Map<String, Object?>> mapObject =
        await db.rawQuery('SELECT * FROM product WHERE sku = "${product.sku}"');
    int result = 0;
    if (mapObject.isEmpty) {
      const sql =
          'INSERT INTO product(id, sku, barcode, name, uom, category) VALUES(?,?,?,?,?,?)';
      result = await db.rawInsert(sql, [
        null,
        product.sku,
        product.barcode,
        product.name,
        product.uom,
        product.category
      ]);
    } else {
      final sql = '''
      UPDATE product SET 
      barcode = "${product.barcode}", 
      name = "${product.name}", 
      uom = "${product.uom}", 
      category = "${product.category}" 
      WHERE sku = "${product.sku}"
      ''';
      result = await db.rawUpdate(sql);
    }
    return result > 0;
  }
}
