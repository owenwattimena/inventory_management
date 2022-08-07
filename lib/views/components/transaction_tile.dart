part of 'components.dart';

class TransactionTile extends StatelessWidget {
  final TransactionList transactionList;
  const TransactionTile({Key? key, required this.transactionList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>(); 
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
            // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
        border: const Border(
            // ignore: prefer_const_constructors
            bottom: BorderSide(
          color: Color.fromARGB(255, 222, 222, 222),
        )),
      ),
      child: Column(
        children: [
          TransactionDate(
            dateTime: DateTime.fromMicrosecondsSinceEpoch(
                transactionList.timestemp! * 1000),
            total: transactionList.transaction!.length,
          ),
          IntrinsicHeight(
            child: Column(
              children: transactionList.transaction!.map((transaction) {
                return TransactionItem(
                  onTap: () async {
                    await Navigator.pushNamed(context, '/transaction-detail',
                        arguments: transaction);
                    homeController.getAllTransactionList();
                    Get.delete<TransactionController>();
                  },
                  transactionType: transaction.type,
                  transactionId: transaction.transactionId,
                  division: transaction.division,
                  totalItem: transaction.totalItem,
                  takeBy: transaction.takeBy,
                  distributor: transaction.distributor,
                  createdBy: transaction.createdBy,
                  warehouse: transaction.warehouse,
                  transactionStatus: transaction.status!
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
