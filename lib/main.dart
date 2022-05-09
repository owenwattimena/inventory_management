import 'package:flutter/material.dart';

import 'models/product.dart';
import 'models/transaction.dart';
import 'views/pages/pages.dart';

void main() {
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
        // '/product-detail': (context) => ProductDetailPage(),
        // '/transaction-detail': (context) => const TransactionDetailPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/transaction-detail') {
          return MaterialPageRoute(
            builder: (context) => TransactionDetailPage(settings.arguments as Transaction),
          );
        } 
        else if(settings.name == '/product-detail') {
          return MaterialPageRoute(
            builder: (context) => ProductDetailPage(settings.arguments as Product),
          );
        }
        return null;
      },
      // home: const HomePage(),
    );
  }
}
