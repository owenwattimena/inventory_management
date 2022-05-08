import 'transaction.dart';

class TransactionList {
  final int? timestemp;
  final List<Transaction>? transaction;

  TransactionList({this.timestemp, this.transaction});

  // factory TransactionList.fromJson(Map<String, dynamic> json, {int? totalTransaction, Transaction? transaction}) => TransactionList(
  //       timestemp: json['created_at'],
  //       totalTransaction: totalTransaction,
  //       transaction: transaction,
  //     );
}

List<Map<String, dynamic>> transaction = [
  {
    'id': 1,
    'transaction_id': '2020220427123209',
    'transaction_type': 'entry',
    'unit': null,
    'distributor': 'CV. ANRLANGGA',
    'take_by': null,
    'created_by': null,
    'warehouse': null,
    'created_at': 1651330800000,
    'total_item': 1,
    'status' : 'panding'
  },
  {
    'id': 2,
    'transaction_id': '2020220427123209',
    'transaction_type': 'audit',
    'unit': null,
    'distributor': null,
    'take_by': null,
    'created_by': 'Owen Wattimena',
    'warehouse': 'Gudang ATK',
    'created_at': 1651330800000,
    'total_item': 10,
    'status' : 'panding'
  },
  {
    'id': 3,
    'transaction_id': '2020220428123209',
    'transaction_type': 'out',
    'unit': 'SDM, Perencanaan & Umum',
    'distributor': null,
    'take_by': 'Owen Wattimena',
    'created_by': null,
    'warehouse': null,
    'created_at': 1647068308183,
    'total_item': 100,
    'status' : 'finished'
  },
];

List<Map<String, dynamic>> transactionDetail = [
  {
    'id': 1,
    'transaction_id': '2020220427123209',
    'sku': 'ATK002',
    'barcode': '1234567890123',
    'name': 'Alas Mouse',
    'uom': 'Pcs',
    'category': 'Alat Tulis Kantor',
    'stock': 15,
  }
];
List<Map<String, dynamic>> transactionWithDetail = [
  {
    'id': 1,
    'transaction_id': '2020220427123209',
    'transaction_type': 'entry',
    'unit': null,
    'distributor': 'CV. ANRLANGGA',
    'take_by': null,
    'created_at': '1651122168787',
    'transaction_detail_id': 1,
    'sku': 'ATK001',
    'stok': 15,
    'last_stock': 15,
  }
];
