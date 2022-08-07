part of 'components.dart';

class TransactionItem extends StatelessWidget {
  final TransactionType? transactionType;
  final String? transactionId;
  final String? division;
  final String? warehouse;
  final int? totalItem;
  final String? createdBy;
  final String? takeBy;
  final String? distributor;
  final TransactionStatus transactionStatus;
  final Function() onTap;
  const TransactionItem(
      {Key? key,
      required this.onTap,
      this.transactionType,
      this.transactionId,
      this.division,
      this.warehouse,
      this.totalItem,
      this.createdBy,
      this.takeBy,
      this.distributor,
      required this.transactionStatus})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        width: double.infinity,
        color: transactionStatus == TransactionStatus.pending ? const Color(0xfffbe9c5) : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#$transactionId',
                  style: primaryTextStyleBold,
                ),
                Text('$totalItem item(s)'),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  (transactionType == TransactionType.out)
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                              child: Text('$division',
                                  overflow: TextOverflow.ellipsis))
                      : /*(transactionType == TransactionType.audit)
                        ? Text('$warehouse')
                        : */
                      const SizedBox(),
                  (transactionType == TransactionType.audit)
                      ? Text(
                          '$createdBy',
                          overflow: TextOverflow.ellipsis,
                        )
                      : const SizedBox(),
                  (transactionType == TransactionType.entry)
                      ? Text(
                          '$distributor',
                          overflow: TextOverflow.ellipsis,
                        )
                      : const SizedBox(),
                ]),
            (transactionType == TransactionType.out)
                ? Text(
                    '$takeBy',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
