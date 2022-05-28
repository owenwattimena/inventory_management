import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../models/transaction.dart';
import '../repository/product_repository.dart';

class ProductTransactionController extends GetxController {
  Rx<List<Transaction>> listProductTransaction = Rx<List<Transaction>>([]);
  RxString selectedTransaction = "all".obs;

  void getListItem(
    String sku,
    int startDate,
    int endDate,
  ) {
    ProductRepository.getProductTransaction(sku, startDate, endDate,
            filter: selectedTransaction.value)
        .then((value) {
      listProductTransaction.update((val) {
        listProductTransaction.value = value;
      });
    });
  }

  Future<void> exportProductTransaction(
    String sku,
    int startDate,
    int endDate,
    String barcode,
    String productName,
    String category,
    String uom,
  ) async {
    String _share = await ProductRepository.exportProductTransaction(
      sku,
      startDate,
      endDate,
      filter: selectedTransaction.value,
      barcode: barcode,
      productName: productName,
      category: category,
      uom: uom,
    );
    Share.shareFiles([_share]);
  }
}
