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


  void getChartData(int dateStart, int dateEnd) {
    TransactionRepository.groupTransactionProduct(dateStart: dateStart,
        dateEnd: dateEnd).then((value) {
      pieData.value = value;

      for (var element in value) {
        total += element.stock!;
      }
    });
  }
}