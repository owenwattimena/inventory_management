part of 'pages.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({Key? key}) : super(key: key);

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  final backupController = Get.put(BackupController());
  final _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup'),
      ),
      body: ListView(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                    "Your backup data is kept in '/Document/InventoryManagement' folder on your device only. ")),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey[200]!, width: 0.5),
              ),
              title: const Text('Data Backup'),
              subtitle: const Text('Export backup file from this device.'),
              trailing: const Icon(Icons.chevron_right_sharp),
              onTap: () async {
                if (await backupController.saveBackup()) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Backup file has been saved to "/Document/InventoryManagement" folder on your device.'),
                  ));
                }
              },
            ),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey[200]!, width: 0.5),
              ),
              title: const Text('Share Backup'),
              subtitle: const Text('Share backup file from this device.'),
              trailing: const Icon(Icons.chevron_right_sharp),
              onTap: () {
                backupController.shareBackup();
              },
            ),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey[200]!, width: 0.5),
              ),
              title: const Text('Data Recovery'),
              subtitle: const Text('Import backup file to this device.'),
              trailing: const Icon(Icons.chevron_right_sharp),
              onTap: () async {
                if (await backupController.openFilePicker()) {
                  showRestoreConfirm();
                }
              },
            ),
          ]),
    );
  }

  Future<void> showRestoreConfirm() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content:
            const Text('Are you sure you want to restore the selected data?'),
        actions: [
          ElevatedButton(
            child: const Text('NO'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('YES'),
            onPressed: () async {
              try{
                if (await backupController.restoreBackup()) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Backup file has been restored.'),
                  ));
                  _homeController.getAllTransactionList(
                      dateStart: _homeController.getDateStart(),
                      dateEnd: _homeController.getDateEnd());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Backup file has not been restored.'),
                  ));
                }
              }on Exception catch(e)
              {
                print(e.toString());
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
