import 'package:get/get.dart';
// import '../models/pie_chart.dart';
import '../models/product.dart';
import '../repository/transaction_repository.dart';
class ChartController extends GetxController{
  Rx<List<Product>> pieData = Rx<List<Product>>([]);
  int total = 0;
  Rx<int?> explodeIndex = Rx<int?>(null);
  Rx<int> colorIndex = Rx<int>(0);
  Rx<int> percentageColor = Rx<int>(0);


  Future<void> getChartData(int dateStart, int dateEnd, {String? division})async{
    final products = await TransactionRepository.groupTransactionProduct(dateStart: dateStart,
        dateEnd: dateEnd, division: division);
      pieData.value = products;
      for (var element in products) {
        total += element.stock!;
      }
  }
}