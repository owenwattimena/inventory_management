import 'package:get/get.dart';
import 'package:inventory_management/repository/transaction_repository.dart';

import '../models/transaction.dart';
import '../models/transaction_list.dart';
import '../repository/division_repository.dart';
import '../repository/product_repository.dart';

class DivisionController extends GetxController {
  List<String> layout = ['transaction', 'product'];
  RxString selectedLayout = 'transaction'.obs;
  Rx<List<String>> divisionList = Rx<List<String>>([]);
  Rx<List<TransactionList?>> outTransactionList = Rx<List<TransactionList>>([]);
  Rx<List<Transaction?>> outTransactionProductList = Rx<List<Transaction>>([]);

  void getDivisionList() async {
    List<String> list = await TransactionRepository.getDivision('');
    divisionList.update((val) {
      divisionList.value = list;
    });
  }

  void getTransaction(String division) async {
    final data = await TransactionRepository.getGroupTransactionByDate(
        type: TransactionType.out, division: division, status: TransactionStatus.finished);
    outTransactionList.update((val) {
      outTransactionList.value = data;
    });
  }
  void getProductTransaction(String division) async {
    List<Transaction?> data = await DivisionRepository.getDivisionProductTransaction(division);
    outTransactionProductList.update((val) {
      outTransactionProductList.value = data;
    });
  }
}
