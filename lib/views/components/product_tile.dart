part of 'components.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({Key? key, required this.product}) : super(key: key);

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
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text('${product.sku}', style: primaryTextStyle.copyWith(color:Colors.grey[700])),
              Text('${product.category}', style: primaryTextStyle.copyWith(color:Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 3),
          Text('${product.name}',
              style: primaryTextStyleBold.copyWith(fontSize: 16)),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(product.barcode ?? '-', style: primaryTextStyle.copyWith(color:Colors.grey[700])),
              Text('${product.stock} ${product.uom}', style: primaryTextStyle.copyWith(color:Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
