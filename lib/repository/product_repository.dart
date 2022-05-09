import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inventory_management/models/transaction.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductRepository {
  
  static Future<List<Product>> getProduct({String? query}) async {
    final productService = ProductService();
    final result = await productService.getProduct(query: query);
    List<Product> data = [];
    for (var i = 0; i < result.length; i++) {
      data.add(Product.fromMapObject(result[i]));
    }
    return data;
  }
  
  static Future<List<Transaction>> getProductTransaction(String sku) async {
    final productService = ProductService();
    final result = await productService.getProductTransaction(sku);
    List<Transaction> data = [];
    for (var i = 0; i < result.length; i++) {
      data.add(Transaction.fromMapObject(result[i]));
    }
    return data;
  }
  
  static Future<void> importFile(PlatformFile file) async {
    final productService = ProductService();
    final input = File(file.path!).openRead();
    final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
    for (int i = 0; i < fields.length; i++) {
      if (i > 0) {
        int j = 1 + i;
        await productService.storeProduct(Product.fromArray(fields[i], j));
      }
    }
  }
}