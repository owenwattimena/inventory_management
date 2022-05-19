part of 'pages.dart';

class DivisionTransactionPage extends StatefulWidget {
  final String division;
  const DivisionTransactionPage(this.division, {Key? key}) : super(key: key);

  @override
  State<DivisionTransactionPage> createState() =>
      _DivisionTransactionPageState();
}

class _DivisionTransactionPageState extends State<DivisionTransactionPage> {
  final divisionController = Get.find<DivisionController>();
  @override
  initState() {
    super.initState();
    divisionController.getTransaction(widget.division);
    divisionController.getProductTransaction(widget.division);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Transaction History',
                  style: primaryTextStyle.copyWith(
                      fontSize: 12, color: Colors.white)),
              Text(widget.division),
            ],
          ),
          actions: [
            Obx(
              () => (divisionController.selectedLayout.value ==
                      divisionController.layout[1])
                  ? IconButton(
                      icon: const Icon(Icons.list),
                      onPressed: () {
                        divisionController.selectedLayout.value =
                            divisionController.layout[0];
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.list_alt),
                      onPressed: () {
                        divisionController.selectedLayout.value =
                            divisionController.layout[1];
                      },
                    ),
            )
          ]),
      body: Obx(() =>  ListView.builder(
            itemCount: (divisionController.selectedLayout.value ==
                      divisionController.layout[0]) ? divisionController.outTransactionList.value.length : divisionController.outTransactionProductList.value.length,
            itemBuilder: (context, index) {
              return (divisionController.selectedLayout.value ==
                      divisionController.layout[0]) ? TransactionTile(
                transactionList:
                    divisionController.outTransactionList.value[index]!,
              ) : ProductHistory(
                showProduct: true,
                transaction: divisionController.outTransactionProductList.value[index]!,
              );
            },
          )),
    );
  }
}
