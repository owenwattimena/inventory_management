import 'package:intl/intl.dart';
import 'package:inventory_management/models/product.dart';

import '../models/transaction.dart';
import '../models/transaction_list.dart';
import '../services/transaction_service.dart';

class TransactionRepository {


  static Future<bool> setTransactionProduct(String transactionId, Product product)async{
    return await TransactionService().setTransactionProduct(transactionId, product);
  }

  static Future<bool> deleteTransactionProduct(String transactionId, String sku)async{
    return await TransactionService().deleteTransactionProduct(transactionId, sku);
  }


  static Future<List<String>> getDivision(String query)async{
    final result = await TransactionService().getDivision(query);
    List<String> division = [];
    for(var i = 0; i < result.length; i++){
      division.add(result[i]['division'].toString());
    }
    return division;
  } 
  
  static Future<List<String>> getTakeBy(String query)async{
    final result = await TransactionService().getTakeBy(query);
    List<String> division = [];
    for(var i = 0; i < result.length; i++){
      division.add(result[i]['take_in_by'].toString());
    }
    return division;
  } 

  static Future<bool> createTransaction(Transaction transaction) async {
    final transactionService = TransactionService();
    final result = await transactionService.createTransaction(transaction);
    return result;
  }

  static Future<List<TransactionList>> getGroupTransactionByDate(
      {required TransactionType type}) async {
    final transactionService = TransactionService();

    String _type = type == TransactionType.entry ? 'entry' : type == TransactionType.out ? 'out' : 'audit';

    final _transaction =
        await transactionService.getGroupTransactionByDate(type: _type);
    if (_transaction.isEmpty) return [];
    List<TransactionList> transactionList = [];
    for (var item in _transaction) {
      int total = await transactionService.getTotalItem(item['transaction_id'].toString());
      int transactionAt = int.parse(item['created_at'].toString());
      var date = DateTime.fromMicrosecondsSinceEpoch(transactionAt * 1000);
      String sStartDate = DateFormat('yyyy-MM-dd 00:00:00').format(date);
      // String sEndDate = DateFormat('yyyy-MM-dd 23:59:59').format(date);

      DateTime startDate = DateTime.parse(sStartDate);
      // DateTime endDate = DateTime.parse(sEndDate);

      int tsStartDate = startDate.millisecondsSinceEpoch;
      // int tsEndDate = endDate.millisecondsSinceEpoch;

      TransactionList _transactionList = transactionList.firstWhere(
          (e) => e.timestemp == tsStartDate,
          orElse: () => TransactionList());

      if (_transactionList.timestemp != null) {
        _transactionList.transaction!.add(Transaction(
          id: int.parse(item['id'].toString()),
          transactionId: item['transaction_id'].toString(),
          type: item['type'] == 'entry'
              ? TransactionType.entry
              : item['type'] == 'out'
                  ? TransactionType.out
                  : TransactionType.audit,
          division: item['division'].toString(),
          distributor: item['distributor'].toString(),
          takeBy: item['take_in_by'].toString(),
          createdBy: item['created_by'].toString(),
          warehouse: item['warehouse'].toString(),
          createdAt: int.parse(item['created_at'].toString()),
          totalItem: total,
          status: item['status'] == 'pending'
              ? TransactionStatus.pending
              : item['status'] == 'finished'
                  ? TransactionStatus.finished
                  : TransactionStatus.canceled,
        ));
      } else {
        transactionList.add(TransactionList(
          timestemp: tsStartDate,
          transaction: [
            Transaction(
              id: int.parse(item['id'].toString()),
              transactionId: item['transaction_id'].toString(),
              type: item['type'] == 'entry'
                  ? TransactionType.entry
                  : item['type'] == 'out'
                      ? TransactionType.out
                      : TransactionType.audit,
              division: item['division'].toString(),
              distributor: item['distributor'].toString(),
              takeBy: item['take_in_by'].toString(),
              createdBy: item['created_by'].toString(),
              warehouse: item['warehouse'].toString(),
              createdAt: int.parse(item['created_at'].toString()),
              totalItem: total,
              status: item['status'] == 'pending'
                  ? TransactionStatus.pending
                  : item['status'] == 'finished'
                      ? TransactionStatus.finished
                      : TransactionStatus.canceled,
            )
          ],
        ));
      }
    }
    return transactionList;
  }

  static Future<List<Product>> getTransactionDetail(
      String transactionId) async {
    final result = await TransactionService().getTransactionDetail(transactionId);
    List<Product> products = [];

    for (var item in result) {
      products.add(Product(
        id: int.parse(item['id'].toString()),
        sku: item['sku'].toString(),
        barcode: item['barcode'].toString(),
        name: item['name'].toString(),
        uom: item['uom'].toString(),
        category: item['category'].toString(),
        stock: (item['quantity'] != null) ? int.parse(item['quantity'].toString()) : 0,
      ));
    }
    return products;
  }
}
