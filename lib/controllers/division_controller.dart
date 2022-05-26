import 'package:get/get.dart';
import 'package:inventory_management/repository/product_repository.dart';
import 'package:inventory_management/repository/transaction_repository.dart';
import 'package:share_plus/share_plus.dart';

import '../models/product.dart';
import '../models/transaction.dart';
import '../models/transaction_list.dart';
import '../repository/division_repository.dart';

class DivisionController extends GetxController {
  List<String> layout = ['transaction', 'product'];
  RxString selectedLayout = 'transaction'.obs;
  Rx<List<String>> divisionList = Rx<List<String>>([]);
  Rx<List<TransactionList?>> outTransactionList = Rx<List<TransactionList>>([]);
  Rx<List<Transaction?>> outTransactionProductList = Rx<List<Transaction>>([]);
  Rx<List<String>> categories = Rx<List<String>>([]);
  RxString dropdownValue = 'All'.obs;
  // RxString selectedProductSku = ''.obs;


  void getDivisionList() async {
    List<String> list = await TransactionRepository.getDivision();
    divisionList.update((val) {
      divisionList.value = list;
    });
  }

  Future<List<String>> getCategory(query) async {
    return await ProductRepository.getCategory();
  }
  Future<List<Product>> getProduct(query) async {
    final product = await ProductRepository.getProduct(query: query);
    List<String> list = [];
    for (var i = 0; i < product.length; i++) {
      list.add(product[i].name!);
    }
    return product;
  }

  void getTransaction(String division, {int? dateStart, int? dateEnd}) async {
    final data = await TransactionRepository.getGroupTransactionByDate(
        type: TransactionType.out,
        division: division,
        status: TransactionStatus.finished,
        dateStart: dateStart,
        dateEnd: dateEnd);
    outTransactionList.update((val) {
      outTransactionList.value = data;
    });
  }

  void getProductTransaction(String division,
      {int? dateStart, int? dateEnd}) async {
    List<Transaction?> data =
        await DivisionRepository.getDivisionProductTransaction(division,
            dateStart: dateStart, dateEnd: dateEnd);
    outTransactionProductList.update((val) {
      outTransactionProductList.value = data;
    });
  }
  Future<void> exportTransaction(String division,{int? dateStart, int? dateEnd, String? category, String? sku})async{
    String _share;
    if (category != null) {
      _share = await DivisionRepository.exportTransaction(division, dateStart: dateStart, dateEnd: dateEnd, category: category);
    } else if (sku != null) {
      _share = await DivisionRepository.exportTransaction(division, dateStart: dateStart, dateEnd: dateEnd,sku: sku);
    }else{
      _share = await DivisionRepository.exportTransaction(division, dateStart: dateStart, dateEnd: dateEnd);
    }
    Share.shareFiles([
      _share
    ]);
  }
}
