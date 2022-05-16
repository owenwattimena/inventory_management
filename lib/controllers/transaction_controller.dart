import 'dart:io';

import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:inventory_management/models/product.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:inventory_management/repository/transaction_repository.dart';

import '../models/transaction.dart';
import '../repository/product_repository.dart';
// import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class TransactionController extends GetxController {
  Rx<List<Product>> products = Rx<List<Product>>([]);
  RxString imagePath = ''.obs;

  Future<bool> setTransaction(String transactionId, Product product) async {
    final result = await TransactionRepository.setTransactionProduct(transactionId, product);
    if(result){
      getTransaction(transactionId);
    }
    return result;
  }

  void getTransaction(String transactionId) {
    TransactionRepository.getTransactionDetail(transactionId).then((value) {
      products.value = value;
    });
  }

  Future<bool> deleteTransactionProduct(String transactionId, String sku) async {
    return await TransactionRepository.deleteTransactionProduct(transactionId, sku);
  }

  Future<List<Product>> searchProduct(String query)async{
    return await ProductRepository.getProduct(query: query);
  }

  Future<File?> saveImage(File file) async {
    try {
      // if (await Permission.storage.request().isGranted) {
      // final PathProviderPlatform provider = PathProviderPlatform.instance;
      // List<String>? listDir = await provider.getExternalStoragePaths(
      //     type: StorageDirectory.downloads);
      Directory? dir = await getApplicationDocumentsDirectory();
      // if (listDir != null) {
      // for (var element in listDir) {
      //   print(element);
      // }
      // var dir = listDir[0];
      // if (listDir.length > 1) {
      //   dir = listDir[1];
      // }

      // var testdir = await Directory('${dir!.path}/iLearn').create(recursive: true);
      var testdir =
          await Directory('${dir.path}/photo').create(recursive: true);
      final image = decodeImage(file.readAsBytesSync());
      return File('${testdir.path}/${DateTime.now().toUtc().toIso8601String()}.png')..writeAsBytesSync(encodePng(image!));
      // }
      // }
    } catch (e) {
      print('error:$e');
      return null;
    }
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted &&
          await Permission.accessMediaLocation.request().isGranted &&
          await Permission.mediaLibrary.request().isGranted &&
          await Permission.manageExternalStorage.request().isGranted) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<bool> deleteTransaction(String transactionId) async {
    return await TransactionRepository.deleteTransaction(transactionId);
  }

  Future<bool> setTransactionFinished(String transactionId, TransactionType type) async {
    return await TransactionRepository.setTransactionFinished(transactionId, type);
  }
}
