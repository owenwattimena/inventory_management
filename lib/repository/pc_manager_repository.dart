import 'package:inventory_management/services/inventory_planning_service.dart';

import '../services/transaction_service.dart';
import '../services/product_service.dart';

class PcManagerRepository {
  static Future<List> getTransaction(String type,
      {int? dateStart, int? dateEnd, String? division}) async {
    var data = await TransactionService().getGroupTransactionByDate(
        type: type, dateStart: dateStart, dateEnd: dateEnd, division: division);
    return data;
  }

  static Future<List> getTransactionDetail(String id) async {
    var data = await TransactionService().getTransactionDetail(id);
    return data;
  }

  static Future<Map<String, dynamic>?> getProductTransactionById(
      String id) async {
    var data = await TransactionService().getProductTransactionById(id);
    return data;
  }

  static Future<List> getProduct({String? sku}) async {
    var data = await ProductService().getProducts(sku: sku);
    return data;
  }

  static Future<List> getDivision({String division = ''}) async {
    var data = await TransactionService().getDivision(division);
    return data;
  }

  static Future<List> getProductTransaction(
      String sku, int startDate, int endDate) async {
    var data =
        await ProductService().getProductTransaction(sku, startDate, endDate);
    return data;
  }

  static Future<List> statistic(
      String type, String sku, int startDate, int endDate) async {
    var data = await ProductService().statistic(type, sku, startDate, endDate);
    return data;
  }

  static Future<List> groupTransactionProduct(int dateStart, int dateEnd,
      {String? division}) async {
    final data = await TransactionService().groupTransactionProduct(
        dateStart: dateStart, dateEnd: dateEnd, division: division);
    return data;
  }

  static Future<List> getCategory({String? category}) async {
    final data = await ProductService().getCategory(query: category);
    return data;
  }

  static Future<List> getInventoryPlanning(
      String category, int monthPlaning) async {
    List<Map<String, dynamic>> planning = [];
    List<Map<String, dynamic>> productStock = await InventoryPlanningService()
        .getInventoryPlanning(category, monthPlaning);
    for (final Map<String, dynamic> item in productStock ) {
      final totalTransaction = await ProductService().totalTransaction(item['sku'], start: DateTime.now().subtract(Duration(days: monthPlaning * 30)), end: DateTime.now());
      if (totalTransaction.isNotEmpty) {
         final Map<String, dynamic> updatedItem = Map<String, dynamic>.from(item);
        // print(totalTransaction[0]['total_transaction']);
        var total = totalTransaction[0]['total_transaction'];
        if (total != null) {
          updatedItem['total_transaction'] = total;
          updatedItem['planning_stock'] = total - updatedItem['stock'];
          if(updatedItem['planning_stock'] < 0){
            continue;
          }
          if(updatedItem['planning_stock'] == 0){
            updatedItem['twenty_percent'] = (20/100 * updatedItem['total_transaction']).ceil();
            updatedItem['planning'] = updatedItem['twenty_percent'] + updatedItem['total_transaction'];
          }else{
            updatedItem['twenty_percent'] = (20/100 * updatedItem['planning_stock']).ceil();
            updatedItem['planning'] = updatedItem['twenty_percent'] + updatedItem['planning_stock'];
          }

          // if(updatedItem['planning_stock'] > 0)
          // {
          //   planning.add(updatedItem);
          // }
          planning.add(updatedItem);
        }
        // else{
        //   updatedItem['total_transaction'] = 0;
        //   updatedItem['planning_stock'] = 0;
          // productStock[i]['total_transaction'] = 0;
        // }
        // planning.add(updatedItem);
      }
    }
    // print(productStock);
    return planning;
  }
}
