part of 'components.dart';

class DrawerHome extends StatelessWidget {
  const DrawerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      // ignore: prefer_const_literals_to_create_immutables
      child: ListView(padding: const EdgeInsets.all(0.0), children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const SizedBox(height: 10),
              Text(
                'Inventory Management',
                style: primaryTextStyleBold.copyWith(fontSize: 20),
              ),
              Text(
                'Version 1.0.0',
                style: primaryTextStyle.copyWith(fontSize: 12),
              ),
              Text(
                'Author @github : owenwattimena',
                style: primaryTextStyle.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 80),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DashSeparator(height: 1.5, color: Colors.grey[400]!),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0, top: 10, bottom: 0),
          child: Text("Menus",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              )),
        ),

        ListTile(
          leading: const Icon(Icons.sync_alt),
          title: const Text('Transaction'),
          onTap: () {
            Navigator.pop(context);
            // Navigator.pushNamed(context, '/transaction-detail');
          },
        ),
        ListTile(
          leading: const Icon(Icons.apps),
          title: const Text('Product'),
          onTap: () async {
            Navigator.pop(context);
            await Navigator.pushNamed(context, '/product');
            Get.delete<ProductController>();
          },
        ),
        ListTile(
          leading: const Icon(Icons.business_outlined),
          title: const Text('Division'),
          onTap: () async {
            Navigator.pop(context);
            await Navigator.pushNamed(context, '/division');
            Get.delete<DivisionController>();
          },
        ),
        ListTile(
          leading: const Icon(Icons.more_horiz),
          title: const Text('More'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/more');
          },
        ),
      ]),
    );
  }
}
