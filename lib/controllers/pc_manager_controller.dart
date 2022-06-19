import 'dart:io';
import "package:get/get.dart";
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter/services.dart';

import '../api/api_router.dart';

class PcManagerController extends GetxController
{
  Rx<String?> host = Rx<String?>(null);
  late HttpServer server;
  void serverDown()async{
    server.close();
    host.value = null;
  }
  void serve()async{
    var app = Router();
    String? wifiIP = await NetworkInfo().getWifiIP();
    app.get('/', (shelf.Request request) async {
      var file = await rootBundle.loadString('public/index.html');
      return shelf.Response.ok(file, headers: {'content-type':'text/html'});
    });
    app.get('/product', (shelf.Request request) async {
      var file = await rootBundle.loadString('public/product.html');
      return shelf.Response.ok(file, headers: {'content-type':'text/html'});
    });
    app.get('/product/<sku>', (shelf.Request request, String sku) async {
      var file = await rootBundle.loadString('public/product-detail.html');
      return shelf.Response.ok(file, headers: {'content-type':'text/html'});
    });

    app.mount('/api', ApiRouter().router);

    app.get('/transaction/<id>', (shelf.Request request, String id)async{
      if(id.isNotEmpty)
      {
        var file = await rootBundle.loadString('public/transaction-detail.html');
        return shelf.Response.ok(file, headers: {'content-type':'text/html'});
      }
      return shelf.Response.notFound('No data');
    });
    if(wifiIP != null){
      server = await io.serve(app, wifiIP, 8080);
      host.value = "http://${server.address.host}:${server.port}";
    }
  }

  // shelf.Response _echoRequest(shelf.Request request) => shelf.Response.ok('Request for "${request.url}"');

}