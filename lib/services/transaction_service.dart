import 'package:sqflite/sqflite.dart';

import '../models/product.dart';
import '../models/transaction.dart' as transacion;

// import '../models/transaction_list.dart';
import 'database_service.dart';

class TransactionService {
  late DatabaseService database;

  TransactionService() {
    database = DatabaseService();
  }

  Future<bool> setTransactionProduct(String transactionId, Product product) async {
    Database db = await database.database;
    var sqlCheck = 'SELECT * FROM transaction_detail WHERE transaction_id = ? AND sku = ?';
    var data = await db.rawQuery(sqlCheck, [transactionId, product.sku]);
    int result = 0;
    if(data.isEmpty) {
    var sql = '''
      INSERT INTO transaction_detail (id, transaction_id, sku, last_stock, quantity, stock) VALUES (?, ?, ?, ?, ?, ?)''';
      result = await db.rawInsert(sql, [null, transactionId, product.sku, null, product.stock, null]);
    }
    return result > 0;
  }
  
  Future<bool> deleteTransactionProduct(String transactionId, String sku) async {
    Database db = await database.database;
    var sqlCheck = 'DELETE FROM transaction_detail WHERE transaction_id = ? AND sku = ?';
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
      {String? type}) async {
    Database db = await database.database;
    List<Map<String, Object?>> mapObject;
    var sql = '''
    SELECT * FROM product_transaction WHERE type = ? ORDER BY created_at DESC
  ''';
    mapObject = await db.rawQuery(sql, [type]);
    print(mapObject);
    return mapObject;
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
    SELECT * FROM transaction_detail AS td JOIN product AS p ON td.sku = p.sku  WHERE td.transaction_id = ?
  ''';
    mapObject = await db.rawQuery(sql, [transactionId]);
    return mapObject;
  }
}
