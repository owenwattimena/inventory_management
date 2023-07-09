

import 'package:inventory_management/services/database_service.dart';

class InventoryPlanningService
{
  late DatabaseService database;

  InventoryPlanningService()
  {
    database = DatabaseService();
  }

  Future<List<Map<String, Object?>>> getInventoryPlanning(String category, int monthPlaning) async
  {
    final db = await database.database;

    var sql = '''
    SELECT p.sku, p.barcode, p.name, p.uom, p.price, td.stock FROM product AS p
      INNER JOIN (
      SELECT * FROM transaction_detail 
      WHERE id IN (
        SELECT MAX(id) FROM transaction_detail GROUP BY sku
        )
      ) as td 
      ON p.sku = td.sku 
      WHERE p.category=?
    GROUP BY p.sku, p.name;
    ''';
    return await db.rawQuery(sql, [category]);
  }
}