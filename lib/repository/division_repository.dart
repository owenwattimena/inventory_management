import '../models/transaction.dart';
import '../services/transaction_service.dart';

class DivisionRepository{
  static Future<List<Transaction>> getDivisionProductTransaction(String division) async {
    final result = await TransactionService().getDivisionProductTransaction(division);
    List<Transaction> data = [];
    for (var i = 0; i < result.length; i++) {
      data.add(Transaction.fromMapObject(result[i]));
    }
    return data;
  }
}