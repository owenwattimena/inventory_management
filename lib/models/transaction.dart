enum TransactionType { out, entry, audit }

enum TransactionStatus { panding, finished, canceled }

class Transaction {
  final int? id;
  final TransactionType? type;
  final String? transactionId;
  final String? division;
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
    this.division,
    this.warehouse,
    this.takeBy,
    this.createdBy,
    this.totalItem,
    this.status,
  });

  factory Transaction.fromMapObject(Map<String, dynamic> json) => Transaction(
        createdAt: json['created_at'],
        transactionId: json['transaction_id'],
        type: json['type'] == 'entry'
            ? TransactionType.entry
            : json['type'] == 'out'
                ? TransactionType.out
                : TransactionType.audit,
        distributor: json['distributor'],
        warehouse: json['warehouse'],
        takeBy: json['take_in_by'],
        division: json['division'],
        totalItem: json['quantity'],
      );
}
