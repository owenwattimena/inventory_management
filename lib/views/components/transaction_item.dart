part of 'components.dart';

class TransactionItem extends StatelessWidget {
  final TransactionType? transactionType;
  final String? transactionId;
  final String? unit;
  final String? warehouse;
  final int? totalItem;
  final String? createdBy;
  final String? takeBy;
  final String? distributor;
  final Function() onTap;
  const TransactionItem({Key? key, required this.onTap, this.transactionType, this.transactionId, this.unit, this.warehouse, this.totalItem, this.createdBy, this.takeBy, this.distributor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#$transactionId',
                  style: primaryTextStyleBold,
                ),
                (transactionType == TransactionType.out)
                    ? Text('$unit')
                    : (transactionType == TransactionType.audit)
                        ? Text('$warehouse')
                        : const SizedBox()
              ],
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('$totalItem item(s)'),
              (transactionType == TransactionType.out)
                  ? Text('$takeBy')
                  : (transactionType == TransactionType.audit)
                      ? Text('$createdBy')
                      : Text('$distributor')
            ])
          ],
        ),
      ),
    );
  }
}
