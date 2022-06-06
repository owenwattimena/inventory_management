import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slugify/slugify.dart';

import '../models/transaction.dart';
import '../services/transaction_service.dart';

class DivisionRepository {
  static Future<List<Transaction>> getDivisionProductTransaction(
      String division,
      {int? dateStart,
      int? dateEnd,
      String? category,
      String? sku}) async {
    final result = await TransactionService().getDivisionProductTransaction(
        division,
        dateStart: dateStart,
        dateEnd: dateEnd,
        productCategory: category,
        productSku: sku);
    List<Transaction> data = [];
    for (var i = 0; i < result.length; i++) {
      data.add(Transaction.fromMapObject(result[i]));
    }
    return data;
  }

  static Future<String> exportTransaction(String division,
      {int? dateStart, int? dateEnd, String? category, String? sku}) async {
    /// Get data transaction of division
    List<Transaction> transaction = await getDivisionProductTransaction(
      division,
      dateStart: dateStart,
      dateEnd: dateEnd,
      category: category,
      sku: sku,
    );

    final excel = Excel.createExcel();

    Sheet  sheetObject = excel['Sheet1'];

    sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 0)).value = 'DIVISION : ' + division;
    if(dateStart != null && dateEnd != null){
      sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 1, columnIndex: 0)).value = 'FORM DATE : ' + DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(dateStart));
      sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 2, columnIndex: 0)).value = 'TO DATE : ' + DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(dateEnd));
    }


    List<dynamic> heading = [
        'DATE',
        'SKU',
        'BARCODE',
        'PRODUCT NAME',
        'UOM',
        'STOCK',
        'CATEGORY',
    ];
    for(var h=0; h<heading.length; h++){
      sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 3, columnIndex: h)).value = heading[h];
    }

    for (var i = 4; i < transaction.length+4; i++) {
      List<dynamic> row = [
        DateFormat('dd-MM-yyyy')
          .format(DateTime.fromMicrosecondsSinceEpoch(transaction[i-4].createdAt! * 1000)),
        transaction[i-4].productSku,
        transaction[i-4].productBarcode,
        transaction[i-4].productName,
        transaction[i-4].productUom,
        transaction[i-4].totalItem,
        transaction[i-4].productCategory,
      ];
      for(var j=0; j<row.length; j++){
        sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: i, columnIndex: j)).value = row[j];
      }
    }

    String slug = slugify(division, delimiter: '_');
    var bytes = excel.save(fileName: '${slug}_transaction_history.xlsx');

    final String directory = (await getTemporaryDirectory()).absolute.path;
    final String path = "$directory/${slug}_transaction_history.xlsx";
    final file = File(path);
    file
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes!);
    return path;
  }
  // static Future<String> exportTransaction(String division,
  //     {int? dateStart, int? dateEnd, String? category, String? sku}) async {
  //   List<Transaction> transaction = await getDivisionProductTransaction(
  //       division,
  //       dateStart: dateStart,
  //       dateEnd: dateEnd,
  //       category: category,
  //       sku: sku);

  //   List<List<dynamic>> rows = [
  //     ['DIVISION : ' + division],
  //     [
  //       dateStart != null
  //           ? 'FROM DATE : ' +
  //               DateFormat('dd-MM-yyyy')
  //                   .format(DateTime.fromMillisecondsSinceEpoch(dateStart))
  //           : ''
  //     ],
  //     [
  //       dateEnd != null
  //           ? 'TO DATE : ' +
  //               DateFormat('dd-MM-yyyy')
  //                   .format(DateTime.fromMillisecondsSinceEpoch(dateEnd))
  //           : ''
  //     ],
  //     [
  //       'DATE',
  //       'SKU',
  //       'BARCODE',
  //       'PRODUCT NAME',
  //       'UOM',
  //       'STOCK',
  //       'CATEGORY',
  //     ]
  //   ];
  //   for (var item in transaction) {
  //     List row = [];
  //     row.add(DateFormat('dd-MM-yyyy')
  //         .format(DateTime.fromMicrosecondsSinceEpoch(item.createdAt! * 1000)));
  //     row.add(item.productSku);
  //     row.add(item.productBarcode);
  //     row.add(item.productName);
  //     row.add(item.productUom);
  //     row.add(item.totalItem);
  //     row.add(item.productCategory);

  //     rows.add(row);
  //   }
  //   String csv = const ListToCsvConverter().convert(rows);
  //   final String directory = (await getTemporaryDirectory()).absolute.path;
  //   // final String directory = (await getExternalStorageDirectory())!.absolute.path;
  //   final String path = "$directory/list-of-transaction.csv";
  //   final file = File(path);
  //   await file.writeAsString(csv);
  //   return path;
  // }
}
