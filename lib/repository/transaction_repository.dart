import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/models/product.dart';

import '../models/transaction.dart';
import '../models/transaction_list.dart';
import '../services/transaction_service.dart';

class TransactionRepository {
  static Future<bool> setTransactionProduct(
      String transactionId, Product product) async {
    return await TransactionService()
        .setTransactionProduct(transactionId, product);
  }

  static Future<bool> setTransactionPhoto(
      String transactionId, String? photo) async {
    return await TransactionService().setTransactionPhoto(transactionId, photo);
  }

  static Future<bool> deleteTransactionPhoto(String photo) async {
    File file = File(photo);
    try {
      await file.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteTransactionProduct(
      String transactionId, String sku) async {
    return await TransactionService()
        .deleteTransactionProduct(transactionId, sku);
  }

  static Future<List<String>> getDivision({String query = ''}) async {
    final result = await TransactionService().getDivision(query);
    List<String> division = [];
    for (var i = 0; i < result.length; i++) {
      division.add(result[i]['division'].toString());
    }
    return division;
  }

  static Future<List<String>> getTakeBy(String query) async {
    final result = await TransactionService().getTakeBy(query);
    List<String> takeInBy = [];
    for (var i = 0; i < result.length; i++) {
      takeInBy.add(result[i]['take_in_by'].toString());
    }
    return takeInBy;
  }

  static Future<List<String>> getDistributor(String query) async {
    final result = await TransactionService().getDistributor(query);
    List<String> distributor = [];
    for (var i = 0; i < result.length; i++) {
      distributor.add(result[i]['distributor'].toString());
    }
    return distributor;
  }

  static Future<bool> createTransaction(Transaction transaction) async {
    return await TransactionService().createTransaction(transaction);
  }

  static Future<List<TransactionList>> getGroupTransactionByDate(
      {required TransactionType type,
      String? division,
      TransactionStatus? status,
      int? dateStart,
      int? dateEnd}) async {
    final transactionService = TransactionService();

    String _type = type == TransactionType.entry
        ? 'entry'
        : type == TransactionType.out
            ? 'out'
            : 'audit';
    String? _status;
    if (status != null) {
      _status = status == TransactionStatus.pending
          ? 'pending'
          : status == TransactionStatus.finished
              ? 'finished'
              : 'Cancelled';
    }

    final _transaction = await transactionService.getGroupTransactionByDate(
        type: _type,
        division: division,
        status: _status,
        dateStart: dateStart,
        dateEnd: dateEnd);
    if (_transaction.isEmpty) return [];
    List<TransactionList> transactionList = [];
    for (var item in _transaction) {
      int total = await transactionService
          .getTotalItem(item['transaction_id'].toString());
      int transactionAt = int.parse(item['created_at'].toString());
      var date = DateTime.fromMicrosecondsSinceEpoch(transactionAt * 1000);
      String sStartDate = DateFormat('yyyy-MM-dd 00:00:00').format(date);
      // String sEndDate = DateFormat('yyyy-MM-dd 23:59:59').format(date);

      DateTime startDate = DateTime.parse(sStartDate);
      // DateTime endDate = DateTime.parse(sEndDate);

      int tsStartDate = startDate.millisecondsSinceEpoch;
      // int tsEndDate = endDate.millisecondsSinceEpoch;

      TransactionList _transactionList = transactionList.firstWhere(
          (e) => e.timestemp == tsStartDate,
          orElse: () => TransactionList());

      if (_transactionList.timestemp != null) {
        _transactionList.transaction!.add(Transaction(
          id: int.parse(item['id'].toString()),
          transactionId: item['transaction_id'].toString(),
          type: item['type'] == 'entry'
              ? TransactionType.entry
              : item['type'] == 'out'
                  ? TransactionType.out
                  : TransactionType.audit,
          division: item['division'].toString(),
          distributor: item['distributor'].toString(),
          takeBy: item['take_in_by'].toString(),
          photo: item['photo'].toString(),
          createdBy: item['created_by'].toString(),
          warehouse: item['warehouse'].toString(),
          createdAt: int.parse(item['created_at'].toString()),
          totalItem: total,
          status: item['status'] == 'pending'
              ? TransactionStatus.pending
              : item['status'] == 'finished'
                  ? TransactionStatus.finished
                  : TransactionStatus.canceled,
        ));
      } else {
        transactionList.add(TransactionList(
          timestemp: tsStartDate,
          transaction: [
            Transaction(
              id: int.parse(item['id'].toString()),
              transactionId: item['transaction_id'].toString(),
              type: item['type'] == 'entry'
                  ? TransactionType.entry
                  : item['type'] == 'out'
                      ? TransactionType.out
                      : TransactionType.audit,
              division: item['division'].toString(),
              distributor: item['distributor'].toString(),
              takeBy: item['take_in_by'].toString(),
              createdBy: item['created_by'].toString(),
              warehouse: item['warehouse'].toString(),
              createdAt: int.parse(item['created_at'].toString()),
              photo: item['photo'].toString(),
              totalItem: total,
              status: item['status'] == 'pending'
                  ? TransactionStatus.pending
                  : item['status'] == 'finished'
                      ? TransactionStatus.finished
                      : TransactionStatus.canceled,
            )
          ],
        ));
      }
    }
    return transactionList;
  }

  static Future<List<Product>> getTransactionDetail(
      String transactionId) async {
    final result =
        await TransactionService().getTransactionDetail(transactionId);
    List<Product> products = [];

    for (var item in result) {
      products.add(Product(
        id: int.parse(item['id'].toString()),
        sku: item['sku'].toString(),
        barcode: item['barcode'].toString(),
        name: item['name'].toString(),
        uom: item['uom'].toString(),
        category: item['category'].toString(),
        price: int.parse(item['price'].toString()),
        stock: (item['quantity'] != null)
            ? int.parse(item['quantity'].toString())
            : 0,
      ));
    }
    return products;
  }

  static Future<bool> deleteTransaction(String transactionId) async {
    return await TransactionService().deleteTransaction(transactionId);
  }

  static Future<bool> setTransactionFinished(
      String transactionId, TransactionType type) async {
    return await TransactionService()
        .setTransactionFinished(transactionId, type);
  }

  static Future<void> importFile(
      PlatformFile file, String transactionId) async {
    final transactionService = TransactionService();
    final input = File(file.path!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    for (int i = 0; i < fields.length; i++) {
      if (i > 0) {
        // int j = 1 + i;
        Product product = Product(
          sku: fields[i][0],
          name: fields[i][1],
          stock: int.parse(fields[i][2].toString()),
        );
        await transactionService.setTransactionProduct(transactionId, product);
      }
    }
  }

  // SAVE IMAGE
  static Future<File> uploadImage(File file) async {
    var storage = await ExternalPath.getExternalStorageDirectories();
    String dir;
    Directory _dir;
    if (storage.length > 1) {
      dir = storage[1];
      _dir = await Directory(dir + "/Pictures/inventory_management").create();
    } else {
      dir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_PICTURES);
      _dir = await Directory(dir + "/inventory_management").create();
    }

    //   // copy the file to a new path
    // final image = decodeImage(file.readAsBytesSync());
    String path = _dir.path +
        "/" +
        DateFormat('yyyyMMddhhmmss').format(DateTime.now()) +
        ".jpg";
    // final _file =  File(path)..writeAsBytesSync(encodePng(image!));
    final _file = file.copy(path);
    return _file;
  }
}
