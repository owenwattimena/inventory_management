import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/services.dart';
import '../router/api_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../router/script_router.dart';
import '../router/style_router.dart';
import '../router/template_router.dart';

class BackgroundService {
  static HttpServer? server;
  // BackgroundService._privateConstructor();

  // static final BackgroundService _instance =
  // BackgroundService._privateConstructor();

  // static BackgroundService get instance => _instance;

  static Future<bool> startServer() async {
    var app = Router();
    app.get('/', (shelf.Request request) async {
      var file = await rootBundle.loadString('public/index.html');
      return shelf.Response.ok(file, headers: {'content-type': 'text/html'});
    });
    app.get('/transaction', (shelf.Request request) async {
      var file = await rootBundle.loadString('public/transaction.html');
      return shelf.Response.ok(file, headers: {'content-type': 'text/html'});
    });
    app.get('/product', (shelf.Request request) async {
      var file = await rootBundle.loadString('public/product.html');
      return shelf.Response.ok(file, headers: {'content-type': 'text/html'});
    });
    app.get('/division', (shelf.Request request) async {
      var file = await rootBundle.loadString('public/division.html');
      return shelf.Response.ok(file, headers: {'content-type': 'text/html'});
    });
    app.get('/division-history', (shelf.Request request) async {
      var file = await rootBundle.loadString('public/division-history.html');
      return shelf.Response.ok(file, headers: {'content-type': 'text/html'});
    });
    app.get('/product/<sku>', (shelf.Request request, String sku) async {
      var file = await rootBundle.loadString('public/product-detail.html');
      return shelf.Response.ok(file, headers: {'content-type': 'text/html'});
    });

    app.get('/transaction/<id>', (shelf.Request request, String id) async {
      if (id.isNotEmpty) {
        var file =
            await rootBundle.loadString('public/transaction-detail.html');
        return shelf.Response.ok(file, headers: {'content-type': 'text/html'});
      }
      return shelf.Response.notFound('No data');
    });

    app.get('/transaction-item', (shelf.Request request) async {
      var file = await rootBundle.loadString('public/transaction-item.html');
      return shelf.Response.ok(file, headers: {'content-type': 'text/html'});
    });

    // Inventory Planning
    app.get('/inventory-planning', (shelf.Request request) async {
      var file = await rootBundle.loadString('public/inventory-planning.html');
      return shelf.Response.ok(file, headers: {'content-type': 'text/html'});
    });

    // API
    app.mount('/api', ApiRouter().router);
    app.mount('/css', StyleRouter().router);
    app.mount('/template', TemplateRouter().router);
    app.mount('/script', ScriptRouter().router);

    try {
      String? wifiIP = await NetworkInfo().getWifiIP();

      if (wifiIP != null) {
        server = await io.serve(app, wifiIP, 8080);
        var host = "http://${server!.address.host}:${server!.port}";
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('host', host);
        // return "true";
        return true;
      }
      return false;
    } catch (e) {
      // print(e.toString());
      return false;
    }
  }

  static serverDown() async {
    if (server != null) {
      server!.close();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('host', '');
    }
  }

  static Future<String?> getHost() async {
    final prefs = await SharedPreferences.getInstance();
    String? host = prefs.getString('host');
    return host;
  }
}
