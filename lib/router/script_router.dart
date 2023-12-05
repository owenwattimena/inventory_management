// import 'dart:io';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:flutter/services.dart';
class ScriptRouter {
  Router get router {
    var route = Router();
    route.get('/config.js', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/js/config.js');
        // Kembalikan respons
        return shelf.Response.ok(file, headers: {'content-type': 'text/javascript'});
    });
    route.get('/main-controller.js', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/js/main-controller.js');
        // Kembalikan respons
        return shelf.Response.ok(file, headers: {'content-type': 'text/javascript'});
    });
    route.get('/transaction-controller.js', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/js/transaction-controller.js');
        return shelf.Response.ok(file, headers: {'content-type': 'text/javascript'});
    });
    route.get('/transaction-item-controller.js', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/js/transaction-item-controller.js');
        return shelf.Response.ok(file, headers: {'content-type': 'text/javascript'});
    });
    route.get('/transaction-detail-controller.js', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/js/transaction-detail-controller.js');
        return shelf.Response.ok(file, headers: {'content-type': 'text/javascript'});
    });
    route.get('/product-controller.js', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/js/product-controller.js');
        return shelf.Response.ok(file, headers: {'content-type': 'text/javascript'});
    });
    route.get('/product-detail-controller.js', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/js/product-detail-controller.js');
        return shelf.Response.ok(file, headers: {'content-type': 'text/javascript'});
    });
    route.get('/division-controller.js', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/js/division-controller.js');
        return shelf.Response.ok(file, headers: {'content-type': 'text/javascript'});
    });
    route.get('/division-history-controller.js', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/js/division-history-controller.js');
        return shelf.Response.ok(file, headers: {'content-type': 'text/javascript'});
    });
    route.get('/inventory-planning-controller.js', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/js/inventory-planning-controller.js');
        return shelf.Response.ok(file, headers: {'content-type': 'text/javascript'});
    });
    return route;
  }
}
