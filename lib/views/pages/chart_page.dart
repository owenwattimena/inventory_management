part of "pages.dart";

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final homeController = Get.find<HomeController>();
  final chartController = Get.put(ChartController());
  @override
  initState() {
    super.initState();
    chartController.getChartData(
        homeController.getDateStart(), homeController.getDateEnd());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Out Statistics'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Obx(
              () => chartController.pieData.value.isNotEmpty ? SfCircularChart(
                  backgroundColor: Colors.white,
                  tooltipBehavior: TooltipBehavior(
                      enable: true,
                      shouldAlwaysShow: true,
                      opacity: 0,
                      builder: (data, point, series, pointIndex, seriesIndex) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            border: Border.all(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${data.name}',
                                  style: primaryTextStyle,
                                ),
                                Text(
                                  '${data.stock} ${data.uom}',
                                  style: primaryTextStyle.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  legend: Legend(isVisible: false),
                  series: <PieSeries<Product, String>>[
                    PieSeries<Product, String>(
                      // onPointTap: (ChartPointDetails pointTap) {
                      //   chartController.explodeIndex.value = pointTap.pointIndex;
                      // },
                      // explode: true,
                      // explodeIndex: chartController.explodeIndex.value,
                      pointColorMapper: (product, index) {
                        if (chartController.colorIndex.value %
                                chartColor.length ==
                            0) {
                          chartController.colorIndex.value = 0;
                        }
                        var color =
                            chartColor[chartController.colorIndex.value];
                        chartController.colorIndex.value += 1;
                        return color;
                      },
                      enableTooltip: true,
                      dataSource: chartController.pieData.value,
                      xValueMapper: (Product data, _) => data.name,
                      yValueMapper: (Product data, _) => data.stock,
                      dataLabelMapper: (Product data, _) =>
                          "${data.name}\n${(data.stock! / chartController.total * 100).toStringAsFixed(1)}%",
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                        connectorLineSettings: ConnectorLineSettings(
                          type: ConnectorType.curve,
                          length: "30%",
                        ),
                      ),
                    ),
                  ]) : const Center(child: Text('No Data.')),
            ),
          ),
          Expanded(
            child: Obx(() => chartController.pieData.value.isNotEmpty ? ListView.builder(
                  itemCount: chartController.pieData.value.length,
                  itemBuilder: (context, index) {
                    var data = chartController.pieData.value[index];
                    if (chartController.percentageColor.value % chartColor.length == 0) {
                      chartController.percentageColor.value = 0;
                    }
                    var color = chartColor[chartController.percentageColor.value];
                    chartController.percentageColor.value += 1;
                    return ListTile(
                      onTap: () async {
                      await Navigator.pushNamed(context, '/product-detail',
                          // arguments: ProductDetailPage(data, selectedTransaction:'out'));
                          arguments: [data, 'out']);
                      Get.delete<ProductTransactionController>();
                    },
                      leading: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '${(data.stock! / chartController.total * 100).toStringAsFixed(1)}%',
                            style:
                                primaryTextStyle.copyWith(color: Colors.white),
                          )),
                      title: Text("${data.name}", style: primaryTextStyle),
                      trailing: Text(
                        '${data.stock} ${data.uom}',
                        style: primaryTextStyle,
                      ),
                    );
                  },
                ) : const Center(child: Text('No Data.'))),
          ),
        ],
      ),
    );
  }
}
