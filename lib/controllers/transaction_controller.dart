import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import 'package:inventory_management/models/product.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:inventory_management/repository/transaction_repository.dart';

import '../models/transaction.dart';
import '../repository/product_repository.dart';
// import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class TransactionController extends GetxController {
  Rx<List<Product>> products = Rx<List<Product>>([]);
  Rx<PlatformFile> file = Rx<PlatformFile>(PlatformFile(name: '', size: 0));
  Rx<String?> imagePath = Rx<String?>(null);


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

  Future<File?> uploadImage(File file) async {
    try {
      return await TransactionRepository.uploadImage(file);
    } catch (e) {
      // print('error:$e');
      return null;
    }
  }


  Future<bool> setTransactionPhoto(String transactionId, String? photo) async {
    final result = await TransactionRepository.setTransactionPhoto(transactionId, photo);
    if(result){
      getTransaction(transactionId);
    }
    return result;
  }
  Future<bool> deleteTransactionPhoto(String photo) async {
    final result = await TransactionRepository.deleteTransactionPhoto(photo);
    return result;
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

   Future<void> importFile(String transactionId) async {
    await TransactionRepository.importFile(file.value, transactionId);
    getTransaction(transactionId);
  }

  Future<void> openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file.value = result.files.first;
    } else {
      // User canceled the picker
    }
  }
}
