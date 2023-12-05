part of "pages.dart";

class PcManagerPage extends StatefulWidget {
  const PcManagerPage({Key? key}) : super(key: key);

  @override
  State<PcManagerPage> createState() => _PcManagerPageState();
}

class _PcManagerPageState extends State<PcManagerPage> {
  final pcManagerController = Get.put(PcManagerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PC Manager")),
      body: Padding(
          padding: const EdgeInsets.all(24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Try Inventory Manager with a web browser!",
                style: primaryTextStyleBold.copyWith(fontSize: 21)),
            const SizedBox(
              height: 12,
            ),
            Obx(() => pcManagerController.host.value != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text("Enter the following address to your browser:",
                            style: primaryTextStyle),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "Server running on ",
                              style: primaryTextStyle),
                          TextSpan(
                              text: "${pcManagerController.host.value}",
                              style: primaryTextStyleBold)
                        ])),
                      ])
                :
                // ignore: prefer_const_literals_to_create_immutables
                Column(children: [
                    // ignore: prefer_const_constructors
                    Text("Click \"Start\" to start the server")
                  ])),
            const SizedBox(
              height: 12,
            ),
            Obx(() => ElevatedButton(
                  onPressed: () async {
                    if (pcManagerController.host.value == null) {
                      // String string = await pcManagerController.serve();

                      if (await BackgroundService.startServer()) {
                        pcManagerController.host.value =
                            await BackgroundService.getHost();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Failed to start server. Please check your wifi connection."),
                          // content: Text(string),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    } else {
                      await BackgroundService.serverDown();
                      pcManagerController.host.value = null;
                    }
                  },
                  child: Text(pcManagerController.host.value == null
                      ? "Start"
                      : "Stop"),
                ))
          ])),
    );
  }
}
