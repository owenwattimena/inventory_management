import 'package:intl/intl.dart';
import 'package:inventory_management/models/product.dart';

import '../models/transaction.dart';
import '../models/transaction_list.dart';
import '../services/transaction_service.dart';

class TransactionRepository {
  static Future<List<TransactionList>> getGroupTransactionByDate(
      {TransactionType? type}) async {
    final _transaction =
        await TransactionService.getGroupTransactionByDate(type: type);
    List<TransactionList> transactionList = [];
    for (var item in _transaction) {
      int transactionAt = item['created_at'];
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
          id: item['id'],
          transactionId: item['transaction_id'],
          type: item['transaction_type'] == 'entry'
              ? TransactionType.entry
              : item['transaction_type'] == 'out'
                  ? TransactionType.out
                  : TransactionType.audit,
          division: item['unit'],
          distributor: item['distributor'],
          takeBy: item['take_by'],
          createdBy: item['created_by'],
          warehouse: item['warehouse'],
          createdAt: item['created_at'],
          totalItem: item['total_item'],
          status: item['status'] == 'panding'
              ? TransactionStatus.panding
              : item['status'] == 'finished'
                  ? TransactionStatus.finished
                  : TransactionStatus.canceled,
        ));
      } else {
        transactionList.add(TransactionList(
          timestemp: tsStartDate,
          transaction: [
            Transaction(
              id: item['id'],
              transactionId: item['transaction_id'],
              type: item['transaction_type'] == 'entry'
                  ? TransactionType.entry
                  : item['transaction_type'] == 'out'
                      ? TransactionType.out
                      : TransactionType.audit,
              division: item['unit'],
              distributor: item['distributor'],
              takeBy: item['take_by'],
              createdBy: item['created_by'],
              warehouse: item['warehouse'],
              createdAt: item['created_at'],
              totalItem: item['total_item'],
              status: item['status'] == 'panding'
                  ? TransactionStatus.panding
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
    final result = await TransactionService.getTransactionDetail(transactionId);
    List<Product> products = [];

    for (var item in result) {
      products.add(Product(
        id: item['id'],
        sku: item['sku'],
        barcode: item['barcode'],
        name: item['name'],
        uom: item['uom'],
        category: item['category'],
        stock: item['stock'],
      ));
    }
    return products;
  }
}
