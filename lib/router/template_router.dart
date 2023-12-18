// import 'dart:io';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:flutter/services.dart';
class TemplateRouter {
  Router get router {
    var route = Router();
    route.get('/lock', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/templates/lock.html');
        // Kembalikan respons
        return shelf.Response.ok(file, headers: {'content-type': 'text/html'});
    });
    route.get('/header', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/templates/header.html');
        // Kembalikan respons
        return shelf.Response.ok(file, headers: {'content-type': 'text/html'});
    });
    route.get('/sidebar', (shelf.Request request) async {
        var file = await rootBundle.loadString('public/templates/sidebar.html');
        // Kembalikan respons
        return shelf.Response.ok(file, headers: {'content-type': 'text/html'});
    });

    return route;
  }
}
