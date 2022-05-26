import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

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
    List<Transaction> transaction = await getDivisionProductTransaction(
        division,
        dateStart: dateStart,
        dateEnd: dateEnd,
        category: category,
        sku: sku);

    List<List<dynamic>> rows = [
      ['DIVISION : ' + division],
      [
        dateStart != null
            ? 'FROM DATE : ' +
                DateFormat('dd-MM-yyyy')
                    .format(DateTime.fromMillisecondsSinceEpoch(dateStart))
            : ''
      ],
      [
        dateEnd != null
            ? 'TO DATE : ' +
                DateFormat('dd-MM-yyyy')
                    .format(DateTime.fromMillisecondsSinceEpoch(dateEnd))
            : ''
      ],
      [
        'DATE',
        'SKU',
        'BARCODE',
        'PRODUCT NAME',
        'UOM',
        'STOCK',
        'CATEGORY',
      ]
    ];
    for (var item in transaction) {
      List row = [];
      row.add(DateFormat('dd-MM-yyyy')
          .format(DateTime.fromMicrosecondsSinceEpoch(item.createdAt! * 1000)));
      row.add(item.productSku);
      row.add(item.productBarcode);
      row.add(item.productName);
      row.add(item.productUom);
      row.add(item.totalItem);
      row.add(item.productCategory);

      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows);
    final String directory = (await getTemporaryDirectory()).absolute.path;
    // final String directory = (await getExternalStorageDirectory())!.absolute.path;
    final String path = "$directory/list-of-transaction.csv";
    final file = File(path);
    await file.writeAsString(csv);
    return path;
  }
}
