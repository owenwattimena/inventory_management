import 'package:sqflite/sqflite.dart';

import '../models/transaction.dart';

import '../models/transaction_list.dart';
import 'database_service.dart';

class TransactionService {
  late DatabaseService database;

  TransactionService() {
    database = DatabaseService();
  }
  Future<List<Map<String, Object?>>> getGroupTransactionByDate(
      {String? type}) async {
    Database db = await database.database;
    List<Map<String, Object?>> mapObject;
    var sql = '''
    SELECT * FROM product_transaction WHERE type = ?
  ''';
    mapObject = await db.rawQuery(sql, [type]);
    return mapObject;
  }

   Future<int> getTotalItem(String transactionId) async {
    Database db = await database.database;
    const sql = 'SELECT COUNT(*) FROM transaction_detail WHERE transaction_id=?';
      int? total = Sqflite.firstIntValue(await db.rawQuery(sql, [
        transactionId
      ]));
      return total ?? 0;
  }

  static Future<List<Map<String, dynamic>>> getTransactionDetail(
      String transactionId) async {
    await Future.delayed(const Duration(seconds: 1));
    final _transactionDetail = transactionDetail
        .where((element) => element['transaction_id'] == transactionId)
        .toList();
    return _transactionDetail;
  }
}
