import 'package:flutter/material.dart';
// import 'package:inventory_management/services/background_service.dart';
// import 'package:workmanager/workmanager.dart';

import 'models/product.dart';
import 'models/transaction.dart';
import 'views/pages/pages.dart';

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     // print(TAG + "callbackDispatcher");
//     await BackgroundService.startServer();
//     // BackGroundWork.instance._loadCounterValue(value + 1);
//     return Future.value(true);
//   });
// }
void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // Workmanager().initialize(
  //   callbackDispatcher, // The top level function, aka callbackDispatcher
  //   isInDebugMode: false // This should be false
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/product': (context) => const ProductPage(),
        '/division': (context) => const DivisionPage(),
        '/more': (context) => const MorePage(),
        '/backup': (context) => const BackupPage(),
        // '/chart' : (context) => const ChartPage(),
        '/pc-manager': (context) => const PcManagerPage(),
        // '/transaction-detail': (context) => const TransactionDetailPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/transaction-detail') {
          return MaterialPageRoute(
            builder: (context) =>
                TransactionDetailPage(settings.arguments as Transaction),
          );
        } else if (settings.name == '/product-detail') {
          return MaterialPageRoute(
            builder: (context) => ProductDetailPage(
                (settings.arguments as List)[0] as Product,
                selectedTransaction: (settings.arguments as List)[1] as String,
                showTypeButton: (settings.arguments as List).length > 2
                    ? (settings.arguments as List)[2]
                    : true),
          );
        } else if (settings.name == '/division-transaction') {
          return MaterialPageRoute(
            builder: (context) =>
                DivisionTransactionPage(settings.arguments as String),
          );
        } else if (settings.name == '/chart') {
          return MaterialPageRoute(
            builder: (context) => ChartPage(
                showChart: (settings.arguments as Map)["showChart"] as bool,
                division: (settings.arguments as Map)["division"] as String?),
          );
        }
        return null;
      },
      // home: const HomePage(),
    );
  }
}
