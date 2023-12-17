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
      return await db.rawQuery('SELECT DISTINCT category FROM product ORDER BY category ASC');
    } else {
      var sql = '''
      SELECT DISTINCT category FROM product WHERE category LIKE '%$query%' ORDER BY category ASC
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

  Future<List<Map<String, Object?>>> getProducts({String? sku, String? category}) async {
    Database db = await database.database;

    if (category != null) {
      String sql = '''
        SELECT * FROM product AS p
        INNER JOIN (
          SELECT * FROM transaction_detail 
          WHERE id IN (
            SELECT MAX(id) FROM transaction_detail GROUP BY sku
          )
        ) as td 
        ON p.sku = td.sku 
        WHERE category = ?
      ''';
      return await db.rawQuery(sql, [category]);
    }
    else if (sku != null) {
      String sql = '''
        SELECT * FROM product AS p
         INNER JOIN (
          SELECT * FROM transaction_detail 
          WHERE id IN (
            SELECT MAX(id) FROM transaction_detail GROUP BY sku
          )
        ) as td 
        ON p.sku = td.sku 
        WHERE p.sku = ?
      ''';
      return await db.rawQuery(sql, [sku]);
    } 
     else {
      String sql = '''
        SELECT * FROM product as p
        INNER JOIN (
          SELECT * FROM transaction_detail 
          WHERE id IN (
            SELECT MAX(id) FROM transaction_detail GROUP BY sku
          )
        ) as td 
        ON p.sku = td.sku 
      ''';
      return await db.rawQuery(sql);
    }
  }

  Future<List<Map<String, Object?>>> getProduct(
      {String? query, String? category, int page = 1}) async {
    int itemPerPage = 20;

    int offset = (page - 1) * itemPerPage;

    Database db = await database.database;
    List<Map<String, Object?>> mapObject;
    List<dynamic> whereArgs;
    if (query == null) {
      if (category == null) {
        var sql = '''
        SELECT * FROM product LIMIT $itemPerPage OFFSET $offset
        ''';
        mapObject = await db.rawQuery(sql);
      } else {
        var sql = '''
        SELECT * FROM product WHERE category = ? LIMIT $itemPerPage OFFSET $offset
        ''';
        whereArgs = [category];
        mapObject = await db.rawQuery(sql, whereArgs);
      }
    } else {
      var sql =
          'SELECT * FROM product WHERE name LIKE "%$query%" OR sku LIKE "%$query%" OR barcode LIKE "%$query%" LIMIT $itemPerPage OFFSET $offset';
      mapObject = await db.rawQuery(sql);
    }
    return mapObject;
  }

  Future<bool> deleteProduct(String sku) async {
    final db = await database.database;
    var sql = '''
    SELECT sku FROM transaction_detail WHERE sku = ?
    ''';
    var result = await db.rawQuery(sql, [sku]);
    if (result.isEmpty) {
      sql = '''
    DELETE FROM product WHERE sku = ?
    ''';
      return (await db.rawDelete(sql, [sku])) > 0;
    } else {
      return false;
    }
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
          'INSERT INTO product(id, sku, barcode, name, uom, category, price) VALUES(?,?,?,?,?,?,?)';
      result = await db.rawInsert(sql, [
        null,
        product.sku,
        product.barcode,
        product.name,
        product.uom,
        product.category,
        product.price
      ]);
    } else {
      final sql = '''
      UPDATE product SET 
      barcode = "${product.barcode}", 
      name = "${product.name}", 
      uom = "${product.uom}", 
      category = "${product.category}",
      price = ${product.price} 
      WHERE sku = "${product.sku}"
      ''';
      result = await db.rawUpdate(sql);
    }
    return result > 0;
  }

  Future<List<Map<String, Object?>>> getProductTransaction(
      String sku, int startDate, int endDate,
      {String? filter}) async {
    Database db = await database.database;
    List<Map<String, Object?>> mapObject;
    String sql;
    List<dynamic> whereArgs;
    if (filter == null || filter == 'all') {
      sql = '''
        SELECT 
        p.uom,
        t.created_at, 
        t.created_by, 
        t.transaction_id, 
        t.type, 
        t.distributor, 
        t.warehouse, 
        t.take_in_by, 
        t.division, 
        td.last_stock,
        td.quantity,
        td.stock
        FROM transaction_detail as td
        JOIN product_transaction as t
        ON td.transaction_id = t.transaction_id
        JOIN product as p
        ON p.sku = td.sku
        WHERE td.sku = ? AND t.status = ? AND t.created_at >= ? AND t.created_at <= ? 
        ORDER BY t.created_at DESC
      ''';
      whereArgs = [sku, "finished", startDate, endDate];
    } else {
      sql = '''
        SELECT 
        p.uom,
        t.created_at, 
        t.created_by, 
        t.transaction_id, 
        t.type, 
        t.distributor, 
        t.warehouse, 
        t.take_in_by, 
        t.division, 
        td.quantity,
        td.stock
        FROM transaction_detail as td
        JOIN product_transaction as t
        ON td.transaction_id = t.transaction_id
        JOIN product as p
        ON p.sku = td.sku
        WHERE td.sku = ? AND t.status = ? AND t.created_at >= ? AND t.created_at <= ? AND t.type = ?
        ORDER BY t.created_at DESC
      ''';
      whereArgs = [sku, "finished", startDate, endDate, filter];
    }

    mapObject = await db.rawQuery(sql, whereArgs);
    return mapObject;
  }

  Future<List> statistic(String type, String sku, int start, int end) async {
    Database db = await database.database;

    String sql = '''
      SELECT   SUM(td.quantity) as quantity
      FROM     transaction_detail AS td
      JOIN     product_transaction AS t
      ON       td.transaction_id = t.transaction_id
      WHERE    t.type = ? 
      AND      t.status = 'finished'
      AND      td.sku = ?
      AND      t.created_at >= ?
      AND      t.created_at <= ?
    ''';
    var mapObject = await db.rawQuery(sql, [type, sku, start, end]);
    return mapObject;
  }

  Future<List> totalTransaction(String sku, {String type = 'out', DateTime? start, DateTime? end}) async {
    Database db = await database.database;
    
    if(start != null && end != null)
    {
      var sql = '''
        SELECT 
          SUM(quantity) AS total_transaction 
        FROM transaction_detail AS td
          JOIN product_transaction AS pt 
            ON td.transaction_id = pt.transaction_id
        WHERE 
        created_at BETWEEN ? AND ?
        AND td.sku = ?
        AND pt.type = ?
      ''';
      var mapObject = await db.rawQuery(sql, [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch,  sku, type ]);
      return mapObject;
    }else{
      var sql = '''
        SELECT 
          SUM(quantity) AS total_transaction 
        FROM transaction_detail AS td
          JOIN product_transaction AS pt 
            ON td.transaction_id = pt.transaction_id
        WHERE 
        AND td.sku = ?
        AND pt.type = ?
      ''';
      var mapObject = await db.rawQuery(sql, [sku, type ]);
      return mapObject;
    }
  }

  Future<List<Map<String, Object?>>> getTotalProduct() async {
    Database db = await database.database;
    var sql = '''
      SELECT COUNT(*) AS total FROM product AS p
        INNER JOIN (
          SELECT * FROM transaction_detail 
          WHERE id IN (
            SELECT MAX(id) FROM transaction_detail GROUP BY sku
          )
        ) as td 
        ON p.sku = td.sku 
        WHERE td.stock > 0
    ''';
    var mapObject = await db.rawQuery(sql);
    return mapObject;
  }
}
