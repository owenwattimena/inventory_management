part of 'pages.dart';

class DivisionTransactionPage extends StatefulWidget {
  final String division;
  const DivisionTransactionPage(this.division, {Key? key}) : super(key: key);

  @override
  State<DivisionTransactionPage> createState() =>
      _DivisionTransactionPageState();
}

class _DivisionTransactionPageState extends State<DivisionTransactionPage> {
  final divisionController = Get.find<DivisionController>();
  final _homeController = Get.find<HomeController>();
  @override
  initState() {
    super.initState();
    reload();
  }

  void reload() {
    divisionController.getTransaction(widget.division,
        dateStart: _homeController.getDateStart(),
        dateEnd: _homeController.getDateEnd());
    divisionController.getProductTransaction(widget.division,
        dateStart: _homeController.getDateStart(),
        dateEnd: _homeController.getDateEnd());
  }

  void monthDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Obx(() => FilterDateDialog(
              onMonthSelected: (month) {
                _homeController.goToMonth(month);
                reload();
                Navigator.pop(context);
              },
              onPrevYear: () {
                _homeController.prevNextYear(prev: true);
                reload();
              },
              onNextYear: () {
                _homeController.prevNextYear(next: true);
                reload();
              },
              activeMonth: _homeController.currentDate.value.month,
              activeYear: _homeController.currentDate.value.year,
              onThisMonthSelected: () {
                _homeController.goToMonth(DateTime.now().month,
                    year: DateTime.now().year);
                reload();
                Navigator.pop(context);
              },
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Transaction History',
                    style: primaryTextStyle.copyWith(
                        fontSize: 12, color: Colors.white)),
                Text(widget.division),
              ],
            ),
            actions: [
              Obx(
                () => (divisionController.selectedLayout.value ==
                        divisionController.layout[1])
                    ? IconButton(
                        icon: const Icon(Icons.list_alt),
                        onPressed: () {
                          divisionController.selectedLayout.value =
                              divisionController.layout[0];
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.list),
                        onPressed: () {
                          divisionController.selectedLayout.value =
                              divisionController.layout[1];
                        },
                      ),
              )
            ]),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 12),
              color: Colors.grey[200]!,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        _showExportDialog();
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.file_copy_sharp, color: Colors.grey),
                          Text(
                            'Export',
                            style: primaryTextStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    // Obx(
                    //   () => divisionController.categories.value.isNotEmpty ? DropdownButton(
                    //     isExpanded: true,
                    //     value: divisionController.selectedCategory.value,
                    //     items: divisionController.categories.value
                    //         .map<DropdownMenuItem<String>>((String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value, style: primaryTextStyle.copyWith(fontSize: 8)),
                    //       );
                    //     }).toList(),
                    //     onChanged: (String? val) {
                    //       divisionController.selectedCategory.value = val!;
                    //     },
                    //   ): const SizedBox(),
                    // ) ,
                    Obx(
                      () => FilterDateButton(
                        foreground: Colors.black,
                        onPrevMonthPressed: () {
                          _homeController.prevNextMonth(prev: true);
                          reload();
                        },
                        onMonthPressed: monthDialog,
                        onNextMonthPressed: () {
                          _homeController.prevNextMonth(next: true);
                          reload();
                        },
                        date: _homeController.currentDate.value,
                      ),
                    ),
                  ]),
            ),
            Expanded(
              child: Obx(
                () => divisionController.outTransactionList.value.isNotEmpty ? ListView.builder(
                  itemCount: (divisionController.selectedLayout.value ==
                          divisionController.layout[0])
                      ? divisionController.outTransactionList.value.length
                      : divisionController
                          .outTransactionProductList.value.length,
                  itemBuilder: (context, index) {
                    return (divisionController.selectedLayout.value ==
                            divisionController.layout[0])
                        ? TransactionTile(
                            transactionList: divisionController
                                .outTransactionList.value[index]!,
                          )
                        : ProductHistory(
                            showProduct: true,
                            transaction: divisionController
                                .outTransactionProductList.value[index]!,
                          );
                  },
                ) : const Center(child: Text('No Data')),
              ),
            )
          ],
        ));
  }

  Future<void> _showExportDialog() async {
    final categoryTextController = TextEditingController();
    final productTextController = TextEditingController();
    String selectedProductSku = "";
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Obx(
          () => AlertDialog(
            title: const Text('Export'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  DropdownButton(
                    isExpanded: true,
                    value: divisionController.dropdownValue.value,
                    items: <String>['All', 'Category', 'Product']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? val) {
                      divisionController.dropdownValue.value = val!;
                    },
                  ),
                  (divisionController.dropdownValue.value != 'All')
                      ? ((divisionController.dropdownValue.value == 'Category')
                          ? TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: categoryTextController,
                                  decoration: const InputDecoration(
                                      labelText: 'Category')),
                              suggestionsCallback: (pattern) {
                                // return CitiesService.getSuggestions(pattern);
                                return divisionController.getCategory(pattern);
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(suggestion.toString()),
                                );
                              },
                              transitionBuilder:
                                  (context, suggestionsBox, controller) {
                                return suggestionsBox;
                              },
                              onSuggestionSelected: (suggestion) {
                                categoryTextController.text =
                                    suggestion.toString();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter category';
                                }
                                return null;
                              },
                            )
                          : TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: productTextController,
                                  decoration: const InputDecoration(
                                      labelText: 'SKU/Barcode/Product name')),
                              suggestionsCallback: (pattern) {
                                // return CitiesService.getSuggestions(pattern);
                                return divisionController.getProduct(pattern);
                              },
                              itemBuilder: (context, Product suggestion) {
                                return ListTile(
                                  title: Text(suggestion.name.toString()),
                                );
                              },
                              transitionBuilder:
                                  (context, suggestionsBox, controller) {
                                return suggestionsBox;
                              },
                              onSuggestionSelected: (Product suggestion) {
                                productTextController.text = suggestion.name!;
                                selectedProductSku = suggestion.sku!;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter SKU/Barcode/Product name';
                                }
                                return null;
                              },
                            ))
                      : const SizedBox(),
                  ElevatedButton(
                    onPressed: () async {
                      if (divisionController.dropdownValue.value == 'All') {
                        await divisionController.exportTransaction(
                            widget.division,
                            dateStart: _homeController.getDateStart(),
                            dateEnd: _homeController.getDateEnd());
                      } else if (divisionController.dropdownValue.value ==
                          'Category') {
                        await divisionController.exportTransaction(
                            widget.division,
                            dateStart: _homeController.getDateStart(),
                            dateEnd: _homeController.getDateEnd(),
                            category: categoryTextController.text);
                      } else {
                        await divisionController.exportTransaction(
                          widget.division,
                          dateStart: _homeController.getDateStart(),
                          dateEnd: _homeController.getDateEnd(),
                          sku: selectedProductSku,
                        );
                      }
                    },
                    child: const Text('EXPORT'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
