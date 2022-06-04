part of "pages.dart";

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final String? selectedTransaction;
  const ProductDetailPage(this.product, {Key? key, this.selectedTransaction }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final productTransactionController = Get.put(ProductTransactionController());
  final _homeController = Get.find<HomeController>();
  final myMenuItems = <String>['Export',];

  late Product product;
  @override
  initState() {
    super.initState();
    product = widget.product;
    if(widget.selectedTransaction != null) {
      productTransactionController.selectedTransaction.value = widget.selectedTransaction!;
    }
    productTransactionController.getListItem(product.sku!,
        _homeController.getDateStart(), _homeController.getDateEnd());
  }

  void monthDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Obx(() => FilterDateDialog(
              onMonthSelected: (month) {
                _homeController.goToMonth(month);
                productTransactionController.getListItem(
                    product.sku!,
                    _homeController.getDateStart(),
                    _homeController.getDateEnd());
                Navigator.pop(context);
              },
              onPrevYear: () {
                _homeController.prevNextYear(prev: true);
                productTransactionController.getListItem(
                    product.sku!,
                    _homeController.getDateStart(),
                    _homeController.getDateEnd());
              },
              onNextYear: () {
                _homeController.prevNextYear(next: true);
                productTransactionController.getListItem(
                    product.sku!,
                    _homeController.getDateStart(),
                    _homeController.getDateEnd());
              },
              activeMonth: _homeController.currentDate.value.month,
              activeYear: _homeController.currentDate.value.year,
              onThisMonthSelected: () {
                _homeController.goToMonth(DateTime.now().month,
                    year: DateTime.now().year);
                productTransactionController.getListItem(
                    product.sku!,
                    _homeController.getDateStart(),
                    _homeController.getDateEnd());
                Navigator.pop(context);
              },
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("${product.name}",
                style: primaryTextStyleBold.copyWith(
                    color: Colors.white, fontSize: 18)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  Text("${product.sku} - ${product.barcode}",
                      style: primaryTextStyle.copyWith(color: Colors.white)),
                ],
              ),
              Text('${product.stock} Pcs',
                  style: primaryTextStyle.copyWith(color: Colors.white)),
            ])
          ]),
          actions: [
            PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return myMenuItems.map((String choice) {
                return PopupMenuItem<String>(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            },
            onSelected: (val) {
              switch (val) {
                case 'Export':
                  productTransactionController.exportProductTransaction(product.sku!,
        _homeController.getDateStart(), _homeController.getDateEnd(), product.barcode!, product.name!, product.category!, product.uom!);
                  break;
                // case 'Pulihkan':
                  // break;
              }
            },
          )
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left:12),
              color: Colors.grey[200]!,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(()=>DropdownButton<String>(
                    value: productTransactionController.selectedTransaction.value,
                      // ignore: prefer_const_literals_to_create_immutables
                      items: [
                        const DropdownMenuItem(
                          child: Text('All'),
                          value: 'all',
                        ),
                        const DropdownMenuItem(
                          child: Text('Entry'),
                          value: 'entry',
                        ),
                        const DropdownMenuItem(
                          child: Text('Out'),
                          value: 'out',
                        ),
                        const DropdownMenuItem(
                          child: Text('Audit'),
                          value: 'audit',
                        ),
                      ],
                      onChanged: (val) {
                        productTransactionController.selectedTransaction.value = val!;
                        productTransactionController.getListItem(
                            product.sku!,
                            _homeController.getDateStart(),
                            _homeController.getDateEnd());
                      
                      }),),
                  Obx(() => FilterDateButton(
                        foreground: Colors.black,
                        onPrevMonthPressed: () {
                          _homeController.prevNextMonth(prev: true);
                          productTransactionController.getListItem(
                              product.sku!,
                              _homeController.getDateStart(),
                              _homeController.getDateEnd());
                        },
                        onMonthPressed: monthDialog,
                        onNextMonthPressed: () {
                          _homeController.prevNextMonth(next: true);
                          productTransactionController.getListItem(
                              product.sku!,
                              _homeController.getDateStart(),
                              _homeController.getDateEnd());
                        },
                        date: _homeController.currentDate.value,
                      )),
                ],
              ),
            ),
            Obx(
              () => productTransactionController
                      .listProductTransaction.value.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: productTransactionController
                            .listProductTransaction.value.length,
                        itemBuilder: (context, index) => ProductHistory(
                          transaction: productTransactionController
                              .listProductTransaction.value[index],
                        ),
                      ),
                    )
                  : const Expanded(
                      child: Center(
                        child: Text('No data'),
                      ),
                    ),
            ),
          ],
        ));
  }
}
