part of 'pages.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final backupController = Get.put(BackupController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              backupController.shareBackup();
            },
            title: const Text('Backup Database'),
          ),
        ],
      ),
    );
  }
}
