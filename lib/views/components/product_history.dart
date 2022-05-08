part of 'components.dart';

class ProductHistory extends StatelessWidget {
  // final Product product;
  const ProductHistory({Key? key}) : super(key: key);

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
              Text('Transaction ID',
                  style: primaryTextStyle.copyWith(color: Colors.grey[700])),
              Text('Tanggal'),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('UNIT|AUDIT|MASUK',
                  style: primaryTextStyleBold.copyWith(fontSize: 16)),
              Text('38 Pcs',
                  style: primaryTextStyle.copyWith(color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 3),
          Text('TAKE IN BY|AUDIT BY|DISTRIBUTOR',
              style: primaryTextStyle.copyWith(color: Colors.grey[700])),
          const SizedBox(height: 14),
          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
