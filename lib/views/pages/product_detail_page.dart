part of "pages.dart";

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Alas Mouse",
              style: primaryTextStyleBold.copyWith(color: Colors.white, fontSize: 18)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Text("ATK001 - 123456",
                    style: primaryTextStyle.copyWith(color: Colors.white)),
              ],
            ),
            Text('35 Pcs',
                style: primaryTextStyle.copyWith(color: Colors.white)),
          ])
        ]),
      ),
      body: ListView(
        children: [
          ProductHistory(),
        ],
      ),
    );
  }
}
