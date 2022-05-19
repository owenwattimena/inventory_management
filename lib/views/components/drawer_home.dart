part of 'components.dart';

class DrawerHome extends StatelessWidget {
  const DrawerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // ignore: prefer_const_literals_to_create_immutables
      child: ListView(padding: const EdgeInsets.all(0.0), children: [
        // ignore: prefer_const_constructors
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text('Inventory Management'),
              const Text('Version 1.0.0'),
            ],
          ),
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
            Get.delete<ProductController>();
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
