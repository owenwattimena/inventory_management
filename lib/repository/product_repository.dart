import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inventory_management/models/transaction.dart';
import 'package:path_provider/path_provider.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../services/transaction_service.dart';

class ProductRepository {

  static Future<List<String>> getCategory({String? query}) async {
    final result = await ProductService().getCategory(query:query);
    List<String> category = [];
    for(var i = 0; i < result.length; i++){
      category.add(result[i]['category'].toString());
    }
    return category;
  }
  
  static Future<List<String>> getUom(String query) async {
    final result = await ProductService().getUom(query);
    List<String> uom = [];
    for(var i = 0; i < result.length; i++){
      uom.add(result[i]['uom'].toString());
    }
    return uom;
  }

  static Future<bool> addProduct(Product product) async {
    final result = await ProductService().addProduct(product);
    return result;
  }

  static Future<List<Product>> getProduct({String? query, String? category}) async {
    final productService = ProductService();
    final result = await productService.getProduct(query: query, category:category);
    List<Product> data = [];
    for (var i = 0; i < result.length; i++) {
      final product = Product.fromMapObject(result[i]);
      final lastTransaction =
          await productService.getLastProductTransaction(product.sku!);
      int stock = 0;
      if (lastTransaction != null) {
        if (lastTransaction['stock'] != null) {
          stock = int.parse(lastTransaction['stock'].toString());
        }
      }
      data.add(product.copyWith(stock: stock));
      // else {
      //   data.add(product.copyWith(stock: stock));
      // }
    }
    return data;
  }

  static Future<List<Transaction>> getProductTransaction(String sku, int startDate, int endDate,{String? filter}) async {
    final result = await TransactionService().getProductTransaction(sku, startDate, endDate, filter: filter);
    List<Transaction> data = [];
    for (var i = 0; i < result.length; i++) {
      data.add(Transaction.fromMapObject(result[i]));
    }
    return data;
  }

  static Future<void> importFile(PlatformFile file) async {
    final productService = ProductService();
    final input = File(file.path!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    for (int i = 0; i < fields.length; i++) {
      if (i > 0) {
        int j = 1 + i;
        await productService.storeProduct(Product.fromArray(fields[i], j));
      }
    }
  }

  static Future<String> exportProduct({String? category}) async{
    List<Product> product = await getProduct(category: category);

    List<List<dynamic>> rows = [
      [
        'SKU',
        'BARCODE',
        'PRODUCT NAME',
        'UOM',
        'STOCK',
        'CATEGORY',
      ]
    ];
    for (var item in product) {
      List row = [];
      row.add(item.sku);
      row.add(item.barcode);
      row.add(item.name);
      row.add(item.uom);
      row.add(item.stock);
      row.add(item.category);

      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows);
    final String directory = (await getTemporaryDirectory()).absolute.path;
    final String path = "$directory/daftar-barang.csv";
    final file = File(path);
    await file.writeAsString(csv);
    return path;
  }
}
