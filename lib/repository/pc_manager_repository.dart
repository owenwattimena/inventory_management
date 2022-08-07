import '../services/transaction_service.dart';
import '../services/product_service.dart';

class PcManagerRepository{

  static Future<List> getTransaction(String type, {int? dateStart, int? dateEnd, String? division})async{
    var data =  await TransactionService().getGroupTransactionByDate(type:type, dateStart: dateStart, dateEnd: dateEnd, division: division);
    return data;
  }
  static Future<List> getTransactionDetail(String id)async{
    var data =  await TransactionService().getTransactionDetail(id);
    return data;
  }
  static Future<Map<String, dynamic>?> getProductTransactionById(String id)async{
    var data =  await TransactionService().getProductTransactionById(id);
    return data;
  }
  static Future<List> getProduct({String? sku})async{
    var data =  await ProductService().getProducts(sku: sku);
    return data;
  }
  static Future<List> getDivision({String division = ''})async{
    var data =  await TransactionService().getDivision(division);
    return data;
  }
  static Future<List> getProductTransaction(String sku, int startDate, int endDate)async{
    var data =  await ProductService().getProductTransaction(sku, startDate, endDate);
    return data;
  }
  static Future<List> statistic(String type,String sku, int startDate, int endDate)async{
    var data =  await ProductService().statistic(type, sku, startDate, endDate);
    return data;
  }
  static Future<List> groupTransactionProduct(int dateStart, int dateEnd, {String? division})async{
    final data = await TransactionService().groupTransactionProduct(dateStart: dateStart, dateEnd: dateEnd, division:division);
    return data;
  }

}