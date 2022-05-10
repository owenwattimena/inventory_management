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

  void getEntryTransaction() {
    TransactionRepository.getGroupTransactionByDate(type: TransactionType.entry).then((value) {
      entryTransactionList.value = value;
    });
  }
  void getOutTransaction() {
    TransactionRepository.getGroupTransactionByDate(type: TransactionType.out).then((value) {
      outTransactionList.value = value;
    });
  }
  void getAuditTransaction() {
    TransactionRepository.getGroupTransactionByDate(type: TransactionType.audit).then((value) {
      auditTransactionList.value = value;
    });
  }
}