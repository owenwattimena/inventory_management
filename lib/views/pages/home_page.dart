part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  final HomeController _homeController = Get.put(HomeController());
  final formOutGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _homeController.getAllTransactionList(
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
                Navigator.pop(context);
              },
              onPrevYear: () => _homeController.prevNextYear(prev: true),
              onNextYear: () => _homeController.prevNextYear(next: true),
              activeMonth: _homeController.currentDate.value.month,
              activeYear: _homeController.currentDate.value.year,
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventory Management',
              style: TextStyle(fontSize: 14)),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () => _homeController.prevNextMonth(prev: true),
                  child: const Icon(
                    Icons.keyboard_arrow_left_sharp,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                TextButton(
                  onPressed: monthDialog,
                  child: Obx(() => Text(
                        DateFormat('MMM yyyy')
                            .format(_homeController.currentDate.value),
                        style: primaryTextStyle.copyWith(color: Colors.white),
                      )),
                ),
                TextButton(
                  onPressed: () => _homeController.prevNextMonth(next: true),
                  child: const Icon(
                    Icons.keyboard_arrow_right_sharp,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            // ignore: prefer_const_literals_to_create_immutables
            tabs: [
              const Tab(text: 'KELUAR'),
              const Tab(text: 'MASUK'),
              const Tab(text: 'AUDIT'),
            ],
          ),
        ),
        drawer: const DrawerHome(),
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            Obx(() => _homeController.outTransactionList.value.isNotEmpty
                ? ListView.builder(
                    itemCount: _homeController.outTransactionList.value.length,
                    itemBuilder: (context, index) {
                      return TransactionTile(
                          transactionList:
                              _homeController.outTransactionList.value[index]!);
                    },
                  )
                : const Center(child: Text('No Data'))),
            Obx(() => _homeController.entryTransactionList.value.isNotEmpty
                ? ListView.builder(
                    itemCount:
                        _homeController.entryTransactionList.value.length,
                    itemBuilder: (context, index) {
                      return TransactionTile(
                          transactionList: _homeController
                              .entryTransactionList.value[index]!);
                    },
                  )
                : const Center(child: Text('No Data'))),
            Obx(() => _homeController.auditTransactionList.value.isNotEmpty
                ? ListView.builder(
                    itemCount:
                        _homeController.auditTransactionList.value.length,
                    itemBuilder: (context, index) {
                      return TransactionTile(
                          transactionList: _homeController
                              .auditTransactionList.value[index]!);
                    },
                  )
                : const Center(child: Text('No Data'))),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final datetime = DateTime.now();
            final divisionTextController = TextEditingController();
            final takeInTextController = TextEditingController();
            final distributorTextController = TextEditingController();
            final createdByTextController = TextEditingController();
            List<String> division = [];
            List<String> takeInBy = [];
            switch (_tabController.index) {
              case 0:
                _showMyDialog(
                  child: Form(
                    key: formOutGlobalKey,
                    child: AlertDialog(
                      title: const Text("Out Transaction"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            DateTimeField(
                              decoration: const InputDecoration(
                                labelText: 'Date of Transaction',
                              ),
                              format: DateFormat("yyyy-MM-dd"),
                              initialValue: datetime,
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: currentValue ?? DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 50)),
                                  lastDate: DateTime.now(),
                                );
                                return date;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter date of transaction';
                                }
                                return null;
                              },
                            ),
                            TypeAheadFormField(
                              minCharsForSuggestions: 3,
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: divisionTextController,
                                  decoration: const InputDecoration(
                                      labelText: 'Division')),
                              suggestionsCallback: (pattern) {
                                return _homeController.getDivision(pattern);
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
                                divisionTextController.text =
                                    suggestion.toString();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter division';
                                }
                                return null;
                              },
                            ),
                            TypeAheadFormField(
                              minCharsForSuggestions: 3,
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: takeInTextController,
                                  decoration: const InputDecoration(
                                      labelText: 'Take In By')),
                              suggestionsCallback: (pattern) {
                                return _homeController.getTakeBy(pattern);
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
                                takeInTextController.text =
                                    suggestion.toString();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter take in by';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('CREATE'),
                          onPressed: () async {
                            if (formOutGlobalKey.currentState!.validate()) {
                              final transaction = Transaction(
                                type: TransactionType.out,
                                transactionId: DateFormat('yyyyMMddhhmmss')
                                    .format(datetime),
                                createdAt: datetime.millisecondsSinceEpoch,
                                division: divisionTextController.text,
                                takeBy: takeInTextController.text,
                                status: TransactionStatus.pending,
                              );
                              if (await _homeController
                                  .createTransaction(transaction)) {
                                _homeController.getOutTransaction();
                                Navigator.of(context).pop();
                                await Navigator.of(context).pushNamed(
                                  '/transaction-detail',
                                  arguments: transaction,
                                );
                                Get.delete<TransactionController>();
                                _homeController.getAllTransactionList();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Error. Can\'t not create transaction'),
                                ));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
                break;
              case 1:
                _showMyDialog(
                  child: Form(
                    key: formOutGlobalKey,
                    child: AlertDialog(
                      title: const Text("Entry Transaction"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            DateTimeField(
                              decoration: const InputDecoration(
                                labelText: 'Date of Transaction',
                              ),
                              format: DateFormat("yyyy-MM-dd"),
                              initialValue: datetime,
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: currentValue ?? DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 50)),
                                  lastDate: DateTime.now(),
                                );
                                return date;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter date of transaction';
                                }
                                return null;
                              },
                            ),
                            TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: distributorTextController,
                                  decoration: const InputDecoration(
                                      labelText: 'Distributor')),
                              suggestionsCallback: (pattern) {
                                // return CitiesService.getSuggestions(pattern);
                                return division
                                    .where(
                                        (element) => element.contains(pattern))
                                    .toList();
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
                                // this._typeAheadController.text = suggestion;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter division';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('CREATE'),
                          onPressed: () async {
                            if (formOutGlobalKey.currentState!.validate()) {
                              final transaction = Transaction(
                                type: TransactionType.entry,
                                transactionId: DateFormat('yyyyMMddhhmmss')
                                    .format(datetime),
                                createdAt: datetime.millisecondsSinceEpoch,
                                distributor: distributorTextController.text,
                                status: TransactionStatus.pending,
                              );
                              if (await _homeController
                                  .createTransaction(transaction)) {
                                _homeController.getOutTransaction();
                                Navigator.of(context).pop();
                                await Navigator.of(context).pushNamed(
                                  '/transaction-detail',
                                  arguments: transaction,
                                );
                                Get.delete<TransactionController>();
                                _homeController.getAllTransactionList();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Error. Can\'t not create transaction'),
                                ));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
                break;
              case 2:
                _showMyDialog(
                  child: Form(
                    key: formOutGlobalKey,
                    child: AlertDialog(
                      title: const Text("Audit Transaction"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            DateTimeField(
                              decoration: const InputDecoration(
                                labelText: 'Date of Transaction',
                              ),
                              format: DateFormat("yyyy-MM-dd"),
                              initialValue: datetime,
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: currentValue ?? DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 50)),
                                  lastDate: DateTime.now(),
                                );
                                return date;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter date of transaction';
                                }
                                return null;
                              },
                            ),
                            TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: createdByTextController,
                                  decoration: const InputDecoration(
                                      labelText: 'Auditor')),
                              suggestionsCallback: (pattern) {
                                // return CitiesService.getSuggestions(pattern);
                                return division
                                    .where(
                                        (element) => element.contains(pattern))
                                    .toList();
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
                                // this._typeAheadController.text = suggestion;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Auditor';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('CREATE'),
                          onPressed: () async {
                            if (formOutGlobalKey.currentState!.validate()) {
                              final transaction = Transaction(
                                type: TransactionType.audit,
                                transactionId: DateFormat('yyyyMMddhhmmss')
                                    .format(datetime),
                                createdAt: datetime.millisecondsSinceEpoch,
                                createdBy: createdByTextController.text,
                                status: TransactionStatus.pending,
                              );
                              if (await _homeController
                                  .createTransaction(transaction)) {
                                _homeController.getOutTransaction();
                                Navigator.of(context).pop();
                                await Navigator.of(context).pushNamed(
                                  '/transaction-detail',
                                  arguments: transaction,
                                );
                                Get.delete<TransactionController>();
                                _homeController.getAllTransactionList();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Error. Can\'t not create transaction'),
                                ));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
                break;
            }
          },
          child: const Icon(Icons.add),
        ),
        // bottomNavigationBar: Obx(()=>BottomNavigationBar(
        //   showUnselectedLabels: false,
        //   currentIndex: _homeController.selectedIndex.value,
        //   onTap: (index) {
        //     _homeController.setSelectedIndex = index;
        //   },
        //   // ignore: prefer_const_literals_to_create_immutables
        //   items: [
        //     const BottomNavigationBarItem(
        //       icon: Icon(Icons.sync_alt),
        //       label: 'TRANSACTION',
        //     ),
        //     const BottomNavigationBarItem(
        //       icon: Icon(Icons.apps),
        //       label: 'PRODUCT',
        //     ),
        //     const BottomNavigationBarItem(
        //       icon: Icon(Icons.more_horiz),
        //       label: 'MORE',
        //     ),
        //   ],
        // )),
      ),
    );
  }

  Future<void> _showMyDialog({required Widget child}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return child;
      },
    );
  }
}
