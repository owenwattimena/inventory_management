part of 'pages.dart';

class DivisionPage extends StatefulWidget {
  const DivisionPage({Key? key}) : super(key: key);

  @override
  State<DivisionPage> createState() => _DivisionPageState();
}

class _DivisionPageState extends State<DivisionPage> {
  final divisionController = Get.put(DivisionController());
  @override
  initState() {
    super.initState();
    divisionController.getDivisionList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Division'),
      ),
      body: Column(children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: divisionController.divisionList.value.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: Colors.white,
                  onTap: () {
                    Navigator.pushNamed(context, '/division-transaction',
                        arguments: divisionController.divisionList.value[index]);
                    // Get.delete<DivisionController>();
                  
                  },
                  title: Text(divisionController.divisionList.value[index]),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[200]!, width: 0.3),
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}
