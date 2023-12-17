import 'dart:io';
import 'package:slugify/slugify.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/models/transaction.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductRepository {

  static Future<List<String>> getCategory({String? query}) async {
    final result = await ProductService().getCategory(query: query);
    List<String> category = [];
    for (var i = 0; i < result.length; i++) {
      category.add(result[i]['category'].toString());
    }
    return category;
  }

  static Future<List<String>> getUom(String query) async {
    final result = await ProductService().getUom(query);
    List<String> uom = [];
    for (var i = 0; i < result.length; i++) {
      uom.add(result[i]['uom'].toString());
    }
    return uom;
  }

  static Future<bool> addProduct(Product product) async {
    final result = await ProductService().storeProduct(product);
    return result;
  }

  /// This method is using to get all of product or product by specific category to export
  static Future<List<Product>> getProducts({String? category}) async {
    final result = await ProductService().getProducts(category: category);

    List<Product> data = [];

    for (var i = 0; i < result.length; i++) {
      final product = Product.fromMapObject(result[i]);
      final lastTransaction =
      await ProductService().getLastProductTransaction(product.sku!);
      int stock = 0;
      if (lastTransaction != null) {
        if (lastTransaction['stock'] != null) {
          stock = int.parse(lastTransaction['stock'].toString());
        }
      }
      data.add(product.copyWith(stock: stock));
    }
    return data;

  }

  static Future<List<Product>> getProduct(
      {String? query, String? category, int page = 1}) async {
    final productService = ProductService();
    final result =
        await productService.getProduct(query: query, category: category, page: page);
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

  static Future<bool> deleteProduct(String sku) async {
    final productService = ProductService();
    final result = await productService.deleteProduct(sku);
    return result;
  }

  static Future<List<Transaction>> getProductTransaction(
      String sku, int startDate, int endDate,
      {String? filter}) async {
    final result = await ProductService()
        .getProductTransaction(sku, startDate, endDate, filter: filter);
    List<Transaction> data = [];
    for (var i = 0; i < result.length; i++) {
      data.add(Transaction.fromMapObject(result[i]));
    }
    return data;
  }

  static Future<String> exportProductTransaction(
      String sku, int startDate, int endDate,
      {String? filter,
      String? barcode,
      String? productName,
      String? category,
      String? uom}) async {


    List<Transaction> transaction =
        await ProductRepository.getProductTransaction(sku, startDate, endDate,
            filter: filter);

    final excel = Excel.createExcel();

    Sheet  sheetObject = excel['Sheet1'];

    sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 0)).value = 'SKU : ' + sku;
    sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 1, columnIndex: 0)).value = 'BARCODE : ' + barcode!;
    sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 2, columnIndex: 0)).value = 'NAME : ' + productName!;
    sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 3, columnIndex: 0)).value = 'CATEGORY : ' + category!;
    sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 4, columnIndex: 0)).value = 'FROM DATE : ' +
            DateFormat('dd-MM-yyyy')
                .format(DateTime.fromMillisecondsSinceEpoch(startDate));
    sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 5, columnIndex: 0)).value = 'TO DATE : ' +
            DateFormat('dd-MM-yyyy')
                .format(DateTime.fromMillisecondsSinceEpoch(endDate));


    List<dynamic> heading = 
      [
        'DATE',
        'TRANSACTION ID',
        'TYPE',
        'TAKE/DIST/AUDIT',
        'QUANTITY',
        'STOCK',
        'UOM',
    ];

    for(var h=0; h<heading.length; h++){
      sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 6, columnIndex: h)).value = heading[h];
    }


    for (var i=7 ; i<transaction.length+7; i++){
      String type = transaction[i-7].type == TransactionType.out
          ? 'OUT'
          : (transaction[i-7].type == TransactionType.entry ? 'ENTRY' : 'AUDIT');
      String desc = transaction[i-7].type == TransactionType.out
          ? transaction[i-7].takeBy!
          : (transaction[i-7].type == TransactionType.entry
              ? transaction[i-7].distributor!
              : transaction[i-7].createdBy!);
      var row = [
        DateFormat('dd-MM-yyyy')
          .format(DateTime.fromMicrosecondsSinceEpoch(transaction[i-7].createdAt! * 1000)),
        transaction[i-7].transactionId,
        type,
        desc,
        transaction[i-7].totalItem,
        transaction[i-7].stock,
        uom,
      ];
      for(var j=0; j<row.length; j++){
        sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: i, columnIndex: j)).value = row[j];
      }
    }
    String slug = slugify(productName, delimiter: '_');
    var bytes = excel.save(fileName: '${slug}_transaction_history.xlsx');

    final String directory = (await getTemporaryDirectory()).absolute.path;
    final String path = "$directory/${slug}_transaction_history.xlsx";
    final file = File(path);
    file
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes!);
    return path;
  }

  static Future<void> importFile(PlatformFile file) async {
    var bytes = File(file.path!).readAsBytesSync();
    try {
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        // print(table); //sheet Name
        // print(excel.tables[table].maxColumns);
        // print(excel.tables[table].maxRows);
        var sheet = excel.tables[table];
        var rows = sheet?.rows;
        if(rows != null)
        {
          // Loop through each row and access its cells
          for (var i = 0; i < rows.length; i++) {
            if(i > 0)
            {
              List data = [];
              for (var cell in rows[i]) {
                data.add(cell?.value);
              }
              await ProductService().storeProduct(Product.fromArrayData(data));
            }
          }
        }
        // var rows = excel.tables[table]?.rows;
        // if (rows != null) {
        //   for (var i = 0; i < rows.length; i++) {
        //   print("$rows[i]");
        //     if (i > 0) {
        //       int j = 1 + i;
        //       await ProductService().storeProduct(Product.fromArray(rows[i], j));
        //     }
        //   }
        // }
      }
      
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<String> exportProduct({String? category}) async {
    List<Product> product = await getProducts(category: category);
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // HEADING
    final heading = [
      'SKU',
      'BARCODE',
      'PRODUCT NAME',
      'UOM',
      'STOCK',
      'PRICE',
      'CATEGORY',
    ];
    for (var h = 0; h < heading.length; h++) {
      var cell = sheetObject
          .cell(CellIndex.indexByColumnRow(columnIndex: h, rowIndex: 0));
      cell.value = heading[h];
    }

    // DATA
    for (var i = 1; i <= product.length; i++) {
      List<dynamic> data = [
        product[i-1].sku,
        product[i-1].barcode,
        product[i-1].name,
        product[i-1].uom,
        product[i-1].stock,
        product[i-1].price,
        product[i-1].category,
      ];
      for (var j = 0; j < data.length; j++) {
        var cell = sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i));
        cell.value = data[j];
      }
    }

    var bytes = excel.save(fileName: 'product_export.xlsx');

    final String directory = (await getTemporaryDirectory()).absolute.path;
    final String path = "$directory/daftar-barang.xlsx";
    final file = File(path);
    file
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes!);
    return path;
  }
}
