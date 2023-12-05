import 'dart:io';
import "package:get/get.dart";
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/services.dart';

import '../router/api_router.dart';
import '../router/style_router.dart';

class PcManagerController extends GetxController {
  Rx<String?> host = Rx<String?>(null);
  late HttpServer server;
  void serverDown() async {
    server.close();
    host.value = null;
  }

  Future<String> serve() async {
    var app = Router();
    app.get('/', (shelf.Request request) async {
      var file = await rootBundle.loadString('public/index.html');
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

    // CSS STYLE
    app.mount('/style', StyleRouter().router);
    // API
    app.mount('/api', ApiRouter().router);

    try {
      String? wifiIP = await NetworkInfo().getWifiIP();

      if (wifiIP != null) {
        server = await io.serve(app, wifiIP, 8888);
        host.value = "http://${server.address.host}:${server.port}";
        return "true";
      }
      return "false";
    } catch (e) {
      return e.toString();
    }
  }

  // shelf.Response _echoRequest(shelf.Request request) => shelf.Response.ok('Request for "${request.url}"');

}
