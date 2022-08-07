import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;

import '../repository/pc_manager_repository.dart';

class ApiRouter {
  Router get router {
    var router = Router();

    router.get('/product', (shelf.Request request) async {
      final data = await PcManagerRepository.getProduct();
      if (data.isNotEmpty) {
        return shelf.Response.ok(json.encode(data),
            headers: {'Content-Type': 'application/json'});
      }
      return shelf.Response.notFound('No data');
    });

    router.post('/product-chart/<sku>',
        (shelf.Request request, String sku) async {
      final result = json.decode(await request.readAsString());
      DateTime? date = DateTime.tryParse(result['date']);
      DateTime? lastday = DateTime(date!.year, date.month + 1, 0);
      lastday =
          DateTime.parse(DateFormat('yyyy-MM-dd 23:59:59').format(lastday));

      final data = await PcManagerRepository.statistic('out', sku,
          date.millisecondsSinceEpoch, lastday.millisecondsSinceEpoch);
      if (data.isNotEmpty) {
        return shelf.Response.ok(json.encode(data),
            headers: {'Content-Type': 'application/json'});
      }
      return shelf.Response.notFound('No data');
    });

    router.get('/product/<sku>', (shelf.Request request, String sku) async {
      if (sku.isNotEmpty) {
        final data = await PcManagerRepository.getProduct(sku: sku);
        if (data.isNotEmpty) {
          return shelf.Response.ok(
            json.encode(data),
            headers: {'Content-Type': 'application/json'},
          );
        }
      }
      return shelf.Response.notFound('No data');
    });
    router.get('/division', (shelf.Request request) async {
      final data = await PcManagerRepository.getDivision();
      if (data.isNotEmpty) {
        return shelf.Response.ok(
          json.encode(data),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return shelf.Response.notFound('No data');
    });

    router.post('/product-statistic', (shelf.Request request) async {
      String? start = request.url.queryParameters['start'];
      String? end = request.url.queryParameters['end'];
      final result = json.decode(await request.readAsString());
      String? division;
      if (result != null) {
        division = result['division'];
      }
      int dateStartInt = 0;
      int dateEndInt = 0;
      if (start != null && end != null) {
        DateTime dateStart = DateTime.parse(start);
        DateTime dateEnd = DateTime.parse(end);
        dateEnd =
            DateTime.parse(DateFormat('yyyy-MM-dd 23:59:59').format(dateEnd));
        dateStartInt = dateStart.millisecondsSinceEpoch;
        dateEndInt = dateEnd.millisecondsSinceEpoch;
      }
      final data = await PcManagerRepository.groupTransactionProduct(
          dateStartInt, dateEndInt,
          division: division);
      return shelf.Response.ok(
        json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.post('/division-history', (shelf.Request request) async {
      String type = "out";
      String? start = request.url.queryParameters['start'];
      String? end = request.url.queryParameters['end'];

      final result = json.decode(await request.readAsString());
      String division = result['division'];
      int? dateStartInt;
      int? dateEndInt;

      if (start != null && end != null) {
        DateTime dateStart = DateTime.parse(start);
        DateTime dateEnd = DateTime.parse(end);
        dateEnd =
            DateTime.parse(DateFormat('yyyy-MM-dd 23:59:59').format(dateEnd));
        dateStartInt = dateStart.millisecondsSinceEpoch;
        dateEndInt = dateEnd.millisecondsSinceEpoch;
      }

      final data = await PcManagerRepository.getTransaction(type,
          dateStart: dateStartInt, dateEnd: dateEndInt, division: division);
      return shelf.Response.ok(
        json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      // return shelf.Response.notFound('No data');
    });

    router.get('/product-transaction/<sku>',
        (shelf.Request request, String sku) async {
      if (sku.isNotEmpty) {
        String? start = request.url.queryParameters['start'];
        String? end = request.url.queryParameters['end'];

        int dateStartInt = 0;
        int dateEndInt = 0;

        if (start != null && end != null) {
          DateTime dateStart = DateTime.parse(start);
          DateTime dateEnd = DateTime.parse(end);
          dateEnd =
              DateTime.parse(DateFormat('yyyy-MM-dd 23:59:59').format(dateEnd));
          dateStartInt = dateStart.millisecondsSinceEpoch;
          dateEndInt = dateEnd.millisecondsSinceEpoch;
        }
        final data = await PcManagerRepository.getProductTransaction(
          sku,
          dateStartInt,
          dateEndInt,
        );
        return shelf.Response.ok(
          json.encode(data),
          headers: {'Content-Type': 'application/json'},
        );
        // if (data.isNotEmpty) {
        // }
      }
      return shelf.Response.notFound('No data');
    });

    router.get('/transaction', (shelf.Request request) async {
      String? type = request.url.queryParameters['type'];
      String? start = request.url.queryParameters['start'];
      String? end = request.url.queryParameters['end'];

      int? dateStartInt;
      int? dateEndInt;

      if (start != null && end != null) {
        DateTime dateStart = DateTime.parse(start);
        DateTime dateEnd = DateTime.parse(end);
        dateEnd =
            DateTime.parse(DateFormat('yyyy-MM-dd 23:59:59').format(dateEnd));
        print(dateEnd);
        dateStartInt = dateStart.millisecondsSinceEpoch;
        dateEndInt = dateEnd.millisecondsSinceEpoch;
      }

      if (type != null) {
        final data = await PcManagerRepository.getTransaction(type,
            dateStart: dateStartInt, dateEnd: dateEndInt);
        // print(data);
        return shelf.Response.ok(json.encode(data),
            headers: {'Content-Type': 'application/json'});
        // if (data.isNotEmpty) {
        // }
      }
      return shelf.Response.notFound('No data');
    });

    router.get('/transaction/<id>', (shelf.Request request, String id) async {
      String? info = request.url.queryParameters['info'];
      if (id.isNotEmpty) {
        if (info == null) {
          final data = await PcManagerRepository.getTransactionDetail(id);
          if (data.isNotEmpty) {
            return shelf.Response.ok(json.encode(data),
                headers: {'Content-Type': 'application/json'});
          }
        } else {
          final data = await PcManagerRepository.getProductTransactionById(id);
          if (data != null) {
            // print(File(data['photo']).path);
            return shelf.Response.ok(json.encode(data),
                headers: {'Content-Type': 'application/json'});
          }
        }
      }
      return shelf.Response.notFound('No data');
    });

    return router;
  }
}
