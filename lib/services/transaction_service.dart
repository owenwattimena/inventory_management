import 'package:sqflite/sqflite.dart';

import '../models/product.dart';
import '../models/transaction.dart' as transacion;

// import '../models/transaction_list.dart';
import '../models/transaction.dart';
import 'database_service.dart';
import 'product_service.dart';

class TransactionService {
  late DatabaseService database;

  TransactionService() {
    database = DatabaseService();
  }

  Future<bool> setTransactionProduct(
      String transactionId, Product product) async {
    Database db = await database.database;
    var sqlCheck =
        'SELECT * FROM transaction_detail WHERE transaction_id = ? AND sku = ?';
    var data = await db.rawQuery(sqlCheck, [transactionId, product.sku]);
    int result = 0;
    if (data.isEmpty) {
      var sql = '''
      INSERT INTO transaction_detail (id, transaction_id, sku, last_stock, quantity, stock) VALUES (?, ?, ?, ?, ?, ?)''';
      result = await db.rawInsert(
          sql, [null, transactionId, product.sku, null, product.stock, null]);
    } else {
      var sql = '''
      UPDATE transaction_detail SET quantity = ? WHERE transaction_id = ? AND sku = ?
  ''';
      result =
          await db.rawUpdate(sql, [product.stock, transactionId, product.sku]);
    }
    return result > 0;
  }

  Future<bool> setTransactionPhoto(
      String transactionId, String? photo) async {
    Database db = await database.database;
    var sqlCheck =
        'SELECT * FROM product_transaction WHERE transaction_id = ?';
    var data = await db.rawQuery(sqlCheck, [transactionId]);
    int result = 0;
    if (data.isNotEmpty) {
      var sql = '''
      UPDATE product_transaction SET photo = ? WHERE transaction_id = ?''';
      result = await db.rawInsert(
          sql, [photo, transactionId]);
    } else {
      result = 0;
    }
    return result > 0;
  }


  Future<bool> deleteTransactionProduct(
      String transactionId, String sku) async {
    Database db = await database.database;
    var sqlCheck =
        'DELETE FROM transaction_detail WHERE transaction_id = ? AND sku = ?';
    var result = await db.rawDelete(sqlCheck, [transactionId, sku]);
    return result > 0;
  }

  Future<List<Map<String, Object?>>> getDivision(String query) async {
    final db = await database.database;
    var sql =
        'SELECT DISTINCT division FROM product_transaction WHERE division LIKE "%$query%"';
    List<Map<String, Object?>> mapObject = await db.rawQuery(sql);
    return mapObject;
  }

  Future<List<Map<String, Object?>>> getTakeBy(String query) async {
    final db = await database.database;
    var sql = '''
    SELECT DISTINCT take_in_by FROM product_transaction WHERE take_in_by LIKE '%$query%'
''';
    List<Map<String, Object?>> mapObject = await db.rawQuery(sql);
    return mapObject;
  }

  Future<List<Map<String, Object?>>> getDistributor(String query) async {
    final db = await database.database;
    var sql = '''
    SELECT DISTINCT distributor FROM product_transaction WHERE distributor LIKE '%$query%'
''';
    List<Map<String, Object?>> mapObject = await db.rawQuery(sql);
    return mapObject;
  }
 
  Future<List<Map<String, Object?>>> getAuditor(String query) async {
    final db = await database.database;
    var sql = '''
    SELECT DISTINCT created_by FROM product_transaction WHERE created_by LIKE '%$query%'
''';
    List<Map<String, Object?>> mapObject = await db.rawQuery(sql);
    return mapObject;
  }

  Future<bool> createTransaction(transacion.Transaction transaction) async {
    final Database db = await database.database;
    var sql = '''
    INSERT INTO product_transaction(
      id, 
      created_at, 
      transaction_id, 
      type, 
      distributor, 
      warehouse, 
      take_in_by, 
      division, 
      created_by, 
      status) 
      VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''';

    String type = transaction.type == transacion.TransactionType.entry
        ? 'entry'
        : transaction.type == transacion.TransactionType.out
            ? 'out'
            : 'audit';
    String status = transaction.status == transacion.TransactionStatus.pending
        ? 'pending'
        : transaction.status == transacion.TransactionStatus.finished
            ? 'finished'
            : 'canceled';
    final result = await db.rawInsert(sql, [
      null,
      transaction.createdAt,
      transaction.transactionId,
      type,
      transaction.distributor,
      transaction.warehouse,
      transaction.takeBy,
      transaction.division,
      transaction.createdBy,
      status
    ]);
    return result > 0;
  }

  Future<List<Map<String, Object?>>> getGroupTransactionByDate(
      {String? type,
      String? division,
      String? status,
      int? dateStart,
      int? dateEnd}) async {
    Database db = await database.database;
    List<Map<String, Object?>> mapObject;
    //   var sql = '''
    //   SELECT * FROM product_transaction WHERE type = ? ORDER BY created_at DESC
    // ''';
    // mapObject = await db.rawQuery(sql, [type]);
    String? where;
    List<dynamic>? whereArgs;
    if (division != null && status != null) {
      where = 'division = ? AND status = ?';
      whereArgs = [division, status];
    } else if (division != null) {
      where = 'division = ?';
      whereArgs = [division];
    } else if (type != null) {
      where = 'type = ?';
      whereArgs = [type];
    }
    if (dateStart != null && dateEnd != null) {
      if (where != null) {
        where += ' AND created_at >= ? AND created_at <= ?';
        whereArgs!.add(dateStart);
        whereArgs.add(dateEnd);
      } else {
        where = 'created_at >= ? AND created_at <= ?';
        whereArgs = [dateStart, dateEnd];
      }
    }

    mapObject = await db.query(
      'product_transaction',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
    );
    return mapObject;
  }

  Future<List<Map<String, Object?>>> groupTransactionProduct(
      {String type = 'out',
      int? dateStart,
      int? dateEnd}) async {
    Database db = await database.database;
    // List<Map<String, Object?>> mapObject;
    String sql = '''
      SELECT p.sku, p.name, SUM(td.quantity) AS total, p.uom, p.barcode, p.category, p.price FROM 
      product_transaction AS t 
      JOIN transaction_detail AS td 
      ON t.transaction_id = td.transaction_id 
      JOIN product AS p
      ON td.sku = p.sku
      WHERE type = ? AND created_at >= ? AND created_at <= ? 
      GROUP BY td.sku
      ORDER BY total DESC
    ''';
    final result = await db.rawQuery(sql, [type, dateStart, dateEnd]);
    return result;
  }

  Future<int> getTotalItem(String transactionId) async {
    Database db = await database.database;
    const sql =
        'SELECT COUNT(*) FROM transaction_detail WHERE transaction_id=?';
    int? total = Sqflite.firstIntValue(await db.rawQuery(sql, [transactionId]));
    return total ?? 0;
  }

  Future<List<Map<String, Object?>>> getTransactionDetail(
      String transactionId) async {
    Database db = await database.database;
    List<Map<String, Object?>> mapObject;
    var sql = '''
    SELECT * FROM 
    transaction_detail AS td 
    JOIN product AS p 
    ON td.sku = p.sku  
    WHERE td.transaction_id = ? 
  ''';
    mapObject = await db.rawQuery(sql, [transactionId]);
    return mapObject;
  }

  Future<bool> deleteTransaction(String transactionId) async {
    Database db = await database.database;
    var sqlCheck = 'DELETE FROM product_transaction WHERE transaction_id = ?';
    var result = await db.rawDelete(sqlCheck, [transactionId]);
    if (result > 0) {
      var sqlCheck = 'DELETE FROM transaction_detail WHERE transaction_id = ?';
      await db.rawDelete(sqlCheck, [transactionId]);
    }
    return result > 0;
  }

  Future<bool> setTransactionFinished(
      String transactionId, TransactionType type) async {
    Database db = await database.database;
    var sql = '''SELECT * FROM transaction_detail WHERE transaction_id=?''';
    var result = await db.rawQuery(sql, [transactionId]);
    if (result.isEmpty) {
      return false;
    }
    for (var item in result) {
      Map<String, Object?>? lastProductStock = await ProductService()
          .getLastProductTransaction(item['sku'].toString());

      int lastStock = 0;
      if (lastProductStock != null) {
        if (lastProductStock['stock'] != null) {
          lastStock = int.parse(lastProductStock['stock'].toString());
        }
      }
      int quantity = int.parse(item['quantity'].toString());
      late int stock;
      switch (type) {
        case transacion.TransactionType.out:
          stock = lastStock - quantity;
          break;
        case transacion.TransactionType.entry:
          stock = lastStock + quantity;
          break;
        case transacion.TransactionType.audit:
          stock = quantity;
          break;
        default:
          stock = 0;
          break;
      }
      var sql =
          '''UPDATE transaction_detail SET last_stock = ?, stock = ? WHERE sku = ? AND transaction_id = ?''';
      await db.rawUpdate(sql, [lastStock, stock, item['sku'], transactionId]);
    }

    sql = '''
    UPDATE product_transaction SET status = 'finished' WHERE transaction_id = ?
  ''';

    return await db.rawUpdate(sql, [transactionId]) > 0;
  }

  Future<List<Map<String, Object?>>> getDivisionProductTransaction(
      String division,
      {int? dateStart,
      int? dateEnd,
      String? productCategory,
      String? productSku}) async {
    Database db = await database.database;
    String sql = '';
    List<dynamic> whereArgs = [];
    if (dateStart != null && dateEnd != null) {
      if (productCategory != null) {
        sql = '''
        SELECT 
        p.sku,
        p.barcode,
        p.name,
        p.uom,
        p.category,
        t.created_at, 
        t.created_by, 
        t.transaction_id, 
        t.type, 
        t.take_in_by, 
        t.division, 
        td.quantity
        FROM transaction_detail as td
        JOIN product_transaction as t
        ON td.transaction_id = t.transaction_id
        JOIN product as p
        ON p.sku = td.sku
        WHERE t.status = ? AND t.division = ? AND t.created_at >= ? AND t.created_at <= ? AND p.category = ?
        ORDER BY t.created_at DESC
      ''';
        whereArgs = ["finished", division, dateStart, dateEnd, productCategory];
      } else if (productSku != null) {
        sql = '''
        SELECT 
        p.sku,
        p.barcode,
        p.name,
        p.uom,
        p.category,
        t.created_at, 
        t.created_by, 
        t.transaction_id, 
        t.type, 
        t.take_in_by, 
        t.division, 
        td.quantity
        FROM transaction_detail as td
        JOIN product_transaction as t
        ON td.transaction_id = t.transaction_id
        JOIN product as p
        ON p.sku = td.sku
        WHERE t.status = ? AND t.division = ? AND t.created_at >= ? AND t.created_at <= ? AND p.sku = ?
        ORDER BY t.created_at DESC
      ''';
        whereArgs = ["finished", division, dateStart, dateEnd, productSku];
      } else {
        sql = '''
        SELECT 
        p.sku,
        p.barcode,
        p.name,
        p.uom,
        p.category,
        t.created_at, 
        t.created_by, 
        t.transaction_id, 
        t.type, 
        t.take_in_by, 
        t.division, 
        td.quantity
        FROM transaction_detail as td
        JOIN product_transaction as t
        ON td.transaction_id = t.transaction_id
        JOIN product as p
        ON p.sku = td.sku
        WHERE t.status = ? AND t.division = ? AND t.created_at >= ? AND t.created_at <= ?
        ORDER BY t.created_at DESC
      ''';
        whereArgs = ["finished", division, dateStart, dateEnd];
      }
    } else {
      sql = '''
        SELECT 
        p.sku,
        p.barcode,
        p.name,
        p.uom,
        p.category,
        t.created_at, 
        t.created_by, 
        t.transaction_id, 
        t.type, 
        t.take_in_by, 
        t.division, 
        td.quantity
        FROM transaction_detail as td
        JOIN product_transaction as t
        ON td.transaction_id = t.transaction_id
        JOIN product as p
        ON p.sku = td.sku
        WHERE t.status = ? AND t.division = ?
        ORDER BY t.created_at DESC
      ''';
      whereArgs = ["finished", division];
    }

    return await db.rawQuery(sql, whereArgs);
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
}
