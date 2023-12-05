// import 'dart:io';

import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:flutter/services.dart';
class StyleRouter {
  Router get router {
    var route = Router();
    route.get('/style.css', (shelf.Request request) async {
        // final file = File('public/css/style.css');
        var file = await rootBundle.loadString('public/css/style.css');
        // Kembalikan respons
        return shelf.Response.ok(file, headers: {'content-type': 'text/css'});
      // try {
      // } on Exception catch (e) {
      //   return shelf.Response.ok(e.toString());
      // }
    });

    return route;
  }
}
