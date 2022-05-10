import 'package:sqflite/sqflite.dart';

import '../models/product.dart';
import 'database_service.dart';

class ProductService {
  late DatabaseService database;

  ProductService() {
    database = DatabaseService();
  }

  Future<List<Map<String, Object?>>> getProduct({String? query}) async {
    Database db = await database.database;
    List<Map<String, Object?>> mapObject;
    if (query == null) {
      const sql = 'SELECT * FROM product';
      mapObject = await db.rawQuery(sql);
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
    product_transaction.created_at, product_transaction.transaction_id, transaction_detail.sku, transaction_detail.quantity 
    FROM transaction_detail 
    JOIN product_transaction
    ON transaction_detail.transaction_id = product_transaction.transaction_id 
    WHERE transaction_detail.sku = ? 
    AND product_transaction.status = ? 
    ORDER BY product_transaction.created_at DESC 
    LIMIT 1
  ''';
    List<Map<String, Object?>> data = await db.rawQuery(sql, [sku, "finished"]);
    if(data.isEmpty) return null;
    return data[0];
  }

  Future<List<Map<String, Object?>>> getProductTransaction(String sku) async {
    Database db = await database.database;
    List<Map<String, Object?>> mapObject;

    var sql = '''
      SELECT 
      t.created_at, 
      t.transaction_id, 
      t.type, 
      t.distributor, 
      t.warehouse, 
      t.take_in_by, 
      t.devision 
      td.quantity
      FROM transaction_detail as td
      WHERE td.sku = ? AND t.status = ?
      JOIN product_transaction as t
      ON td.transaction_id = t.transaction_id
    ''';
    mapObject = await db.rawQuery(sql, [sku, "finished"]);

    return mapObject;
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
