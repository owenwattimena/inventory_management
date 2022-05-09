part of "pages.dart";

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage(this.product, {Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final productTransactionController = Get.put(ProductTransactionController());
  late Product product;
  @override
  initState() {
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
      ),
      body: ListView.builder(
        itemCount: productTransactionController.listProductTransaction.value.length,
        itemBuilder: (context, index) => ProductHistory(),
      ),
    );
  }
}
