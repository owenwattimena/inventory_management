part of 'pages.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final _passcodeController = Get.put(PasscodeController());
  final _homeController = Get.find<HomeController>();

  void setPasscode() {
    if (_homeController.passcode.value == null) {
      screenLock(
        context: context,
        correctString: _passcodeController.passcode.value,
        confirmation: true,
        didConfirmed: (matchedText) async {
          if (await _passcodeController.setPasscode(matchedText)) {
            _homeController.getPasscode();
            Navigator.pop(context);
          }
        },
      );
    } else {
      screenLock(
        context: context,
        correctString: _homeController.passcode.value!,
        didUnlocked: () async {
          if (await _passcodeController.deletePasscode()) {
            _homeController.getPasscode();
            Navigator.pop(context);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => Navigator.pushNamed(context, '/backup'),
            title: const Text('Backup'),
          ),
          Obx(() => ListTile(
                onTap: setPasscode,
                title: const Text('Passcode'),
                trailing: Text(
                    _homeController.passcode.value == null ? 'OFF' : 'ON',
                    style: TextStyle(
                        color: _homeController.passcode.value == null
                            ? Colors.red
                            : Colors.green)),
              )),
        ],
      ),
    );
  }
}
