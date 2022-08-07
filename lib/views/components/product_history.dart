part of 'components.dart';

class ProductHistory extends StatelessWidget {
  final Transaction transaction;
  final bool showProduct;
  const ProductHistory({Key? key, required this.transaction, this.showProduct = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${transaction.transactionId}',
                  style: primaryTextStyle.copyWith(color: Colors.grey[700])), 
              Text(DateFormat('E dd-MM-yyyy').format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            transaction.createdAt! * 1000))),
            ],
          ),
          const SizedBox(height: 3),
           Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text((transaction.type == TransactionType.out
              //         ? ((showProduct) ? '${transaction.productName}' :  '${transaction.division}')
              //         : transaction.type == TransactionType.audit
              //             ? 'AUDIT'
              //             : 'MASUK') ,
              //     style: primaryTextStyleBold.copyWith(fontSize: 16)),
              Text(
                transaction.type != TransactionType.audit ? 
                '${transaction.totalItem} ${transaction.productUom}' : '${transaction.lastStock} ${transaction.productUom}' ,
                  style: primaryTextStyle.copyWith(color: (transaction.type == TransactionType.out
                      ? Colors.red
                      : transaction.type == TransactionType.audit
                          ? Colors.black
                          : Colors.green))),
              const Text(' → '),
              Text(
                transaction.type == TransactionType.audit ? '${transaction.totalItem} ${transaction.productUom}' :
                '${transaction.stock} ${transaction.productUom}',
                style: primaryTextStyle.copyWith(color: transaction.type == TransactionType.audit
                          ? Colors.blueAccent
                          : Colors.black)
              )
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text((transaction.type == TransactionType.out
                      ? ((showProduct) ? '${transaction.productName}' :  '${transaction.division}')
                      : transaction.type == TransactionType.audit
                          ? 'AUDIT'
                          : 'MASUK') ,
                  style: primaryTextStyleBold.copyWith(fontSize: 16)),
              // Text('${transaction.totalItem} ${transaction.productUom}',
              //     style: primaryTextStyle.copyWith(color: (transaction.type == TransactionType.out
              //         ? Colors.red
              //         : transaction.type == TransactionType.audit
              //             ? Colors.blueAccent
              //             : Colors.green))),
            ],
          ),
          const SizedBox(height: 3),
          Text((transaction.type == TransactionType.out
                      ? '${transaction.takeBy}'
                      : transaction.type == TransactionType.audit
                          ? '${transaction.createdBy}'
                          : '${transaction.distributor}'),
              style: primaryTextStyle.copyWith(color: Colors.grey[700])),
          const SizedBox(height: 14),
          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
