import 'package:get/get.dart';
import 'package:inventory_management/models/transaction_list.dart';

import '../models/transaction.dart';
import '../repository/transaction_repository.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  Rx<List<TransactionList?>> entryTransactionList = Rx<List<TransactionList>>([]);
  Rx<List<TransactionList?>> outTransactionList = Rx<List<TransactionList>>([]);
  Rx<List<TransactionList?>> auditTransactionList = Rx<List<TransactionList>>([]);

  set setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  Future<bool> createOutTransaction(Transaction transaction) async {
    final result = await TransactionRepository.createTransaction(transaction);
    return result;
  }

  Future<List<String>> getDivision(String query) async {
    final result = await TransactionRepository.getDivision(query);
    return result;
  }
  Future<List<String>> getTakeBy(String query) async {
    final result = await TransactionRepository.getTakeBy(query);
    return result;
  }

  void getAllTransactionList() {
    getEntryTransaction();
    getOutTransaction();
    getAuditTransaction();
  }

  void getEntryTransaction() {
    TransactionRepository.getGroupTransactionByDate(type: TransactionType.entry).then((value) {
      entryTransactionList.update((val) {
        entryTransactionList.value = value;
      });
    });
  }
  void getOutTransaction() {
    TransactionRepository.getGroupTransactionByDate(type: TransactionType.out).then((value) {
      outTransactionList.update((val) {
        outTransactionList.value = value;
      });
    });
  }
  void getAuditTransaction() {
    TransactionRepository.getGroupTransactionByDate(type: TransactionType.audit).then((value) {
      auditTransactionList.update((val) {
        auditTransactionList.value = value;
      });
    });
  }
}