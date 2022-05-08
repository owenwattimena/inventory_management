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
    _homeController.getEntryTransaction();
    _homeController.getOutTransaction();
    _homeController.getAuditTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventory Management'),
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
            Obx(() => ListView.builder(
                  itemCount: _homeController.outTransactionList.length,
                  itemBuilder: (context, index) {
                    return TransactionTile(
                        transactionList:
                            _homeController.outTransactionList[index]);
                  },
                )),
            Obx(() => ListView.builder(
                  itemCount: _homeController.entryTransactionList.length,
                  itemBuilder: (context, index) {
                    return TransactionTile(
                        transactionList:
                            _homeController.entryTransactionList[index]);
                  },
                )),
            Obx(() => ListView.builder(
                  itemCount: _homeController.auditTransactionList.length,
                  itemBuilder: (context, index) {
                    return TransactionTile(
                        transactionList:
                            _homeController.auditTransactionList[index]);
                  },
                )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final datetime = DateTime.now();
            final unitTextController = TextEditingController();
            final takeInTextController = TextEditingController();
            final distributorTextController = TextEditingController();
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
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: unitTextController,
                                  decoration: const InputDecoration(
                                      labelText: 'Division')),
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
                              },
                            ),
                            TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                  controller: takeInTextController,
                                  decoration: const InputDecoration(
                                      labelText: 'Take In By')),
                              suggestionsCallback: (pattern) {
                                // return CitiesService.getSuggestions(pattern);
                                return takeInBy
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
                                  return 'Please enter take in by';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('CREATE'),
                          onPressed: () {
                            if (formOutGlobalKey.currentState!.validate()) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(
                                '/transaction-detail',
                                arguments: Transaction(
                                  type: TransactionType.out,
                                  transactionId: DateFormat('yyyyMMddhhmmss')
                                      .format(datetime),
                                  createdAt: datetime.millisecondsSinceEpoch,
                                  unit: unitTextController.text,
                                  takeBy: takeInTextController.text,
                                ),
                              );
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
                              },
                            ),
                            
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('CREATE'),
                          onPressed: () {
                            if (formOutGlobalKey.currentState!.validate()) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(
                                '/transaction-detail',
                                arguments: Transaction(
                                  type: TransactionType.out,
                                  transactionId: DateFormat('yyyyMMddhhmmss')
                                      .format(datetime),
                                  createdAt: datetime.millisecondsSinceEpoch,
                                  distributor: distributorTextController.text,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
                break;
              case 2:
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
