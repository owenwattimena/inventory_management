enum TransactionType { out, entry, audit }
enum TransactionStatus { panding, finished, canceled }

class Transaction {
  final int? id;
  final TransactionType? type;
  final String? transactionId;
  final String? unit;
  final String? warehouse;
  final String? takeBy;
  final String? distributor;
  final String? createdBy;
  final int? createdAt;
  final int? totalItem;
  final TransactionStatus? status;

  Transaction({
    this.createdAt,
    this.distributor,
    this.id,
    this.type,
    this.transactionId,
    this.unit,
    this.warehouse,
    this.takeBy,
    this.createdBy,
    this.totalItem,
    this.status,
  });
}
