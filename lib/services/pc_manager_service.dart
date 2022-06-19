import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class PcManagerService{
  late DatabaseService database;

  PcManagerService() {
    database = DatabaseService();
  }
  Future<List<Map<String, Object?>>> getTransaction(String type) async {
    Database db = await database.database;
    List<Map<String, Object?>> mapObject;
    var sql = '''
      SELECT t.transaction_id, p.name, td.quantity, p.uom, t.division FROM 
      transaction_detail AS td 
      JOIN product AS p 
      ON td.sku = p.sku 
      JOIN product_transaction as t 
      ON t.transaction_id = td.transaction_id
      WHERE t.type = ?
    ''';
    mapObject = await db.rawQuery(sql, [type]);
    return mapObject;
  }
}