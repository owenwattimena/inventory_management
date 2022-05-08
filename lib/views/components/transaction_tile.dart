part of 'components.dart';

class TransactionTile extends StatelessWidget {
  final TransactionList transactionList;
  const TransactionTile({Key? key, required this.transactionList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        color: Color(0xffFFFFFF),
        border: Border(
            bottom: BorderSide(
          color: greyColor,
        )),
      ),
      child: Column(
        children: [
          TransactionDate(
            dateTime: DateTime.fromMicrosecondsSinceEpoch(
                transactionList.timestemp! * 1000),
            total: transactionList.transaction!.length,
          ),
          Column(
            children: transactionList.transaction!.map((transaction) {
              return TransactionItem(
                onTap: () async {
                  await Navigator.pushNamed(context, '/transaction-detail',
                      arguments: transaction);
                  Get.delete<TransactionController>();
                },
                transactionType: transaction.type,
                transactionId: transaction.transactionId,
                unit: transaction.unit,
                totalItem: transaction.totalItem,
                takeBy: transaction.takeBy,
                distributor: transaction.distributor,
                createdBy: transaction.createdBy,
                warehouse: transaction.warehouse,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
