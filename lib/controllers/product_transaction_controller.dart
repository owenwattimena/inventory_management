import 'package:get/get.dart';

import '../models/transaction.dart';
import '../repository/product_repository.dart';

class ProductTransactionController extends GetxController {
  Rx<List<Transaction>> listProductTransaction = Rx<List<Transaction>>([]);
  RxString selectedTransaction = "all".obs;

  void getListItem(String sku, int startDate, int endDate,) {
    ProductRepository.getProductTransaction(sku, startDate, endDate, filter:selectedTransaction.value).then((value) {
      listProductTransaction.update((val) {
        listProductTransaction.value = value;
      });
    });
  }
}