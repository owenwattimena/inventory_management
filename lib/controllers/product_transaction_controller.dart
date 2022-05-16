import 'package:get/get.dart';

import '../models/transaction.dart';
import '../repository/product_repository.dart';

class ProductTransactionController extends GetxController {
  Rx<List<Transaction>> listProductTransaction = Rx<List<Transaction>>([]);
  void getListItem(String sku) {
    ProductRepository.getProductTransaction(sku).then((value) {
      listProductTransaction.update((val) {
        listProductTransaction.value = value;
      });
    });
  }
}