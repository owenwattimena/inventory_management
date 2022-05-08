import '../models/transaction.dart';

import '../models/transaction_list.dart';

class TransactionService {
  static Future<List<Map<String, dynamic>>> getGroupTransactionByDate({TransactionType? type}) async {
    await Future.delayed(const Duration(seconds: 1));
    final _transaction = transaction.where((element) => element['transaction_type'] == type.toString().split('.').last).toList();
    return _transaction;
  }

  static Future<List<Map<String, dynamic>>> getTransactionDetail(String transactionId) async
  {
    await Future.delayed(const Duration(seconds: 1));
    final _transactionDetail = transactionDetail.where((element) => element['transaction_id'] == transactionId).toList();
    return _transactionDetail;
  }
}
