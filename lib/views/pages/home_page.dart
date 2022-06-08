part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  final HomeController _homeController = Get.put(HomeController());
  final formOutGlobalKey = GlobalKey<FormState>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        showPasscode();
        break;
      default:
      // case AppLifecycleState.inactive:
      //   print("app in inactive");
      //   break;
      // case AppLifecycleState.paused:
      //   print("app in paused");
      //   break;
      // case AppLifecycleState.detached:
      //   print("app in detached");
      //   break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // _homeController.getPasscode();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        _homeController.isTabOutActive.value = true;
      } else {
        _homeController.isTabOutActive.value = false;
      }
    });
    _homeController.getAllTransactionList();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   showPasscode();
    // });
  }

  void showPasscode() async {
    if (await _homeController.getPasscode() != null) {
      Future.delayed(const Duration(seconds: 0), () {
        if (!_homeController.isPasscodeOn.value) {
          _homeController.isPasscodeOn.value = true;
          screenLock(
            context: context,
            correctString: _homeController.passcode.value!,
            canCancel: false,
            didUnlocked: () {
              _homeController.isPasscodeOn.value = false;
              Navigator.pop(context);
            },
          );
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
              onThisMonthSelected: () {
                _homeController.goToMonth(DateTime.now().month,
                    year: DateTime.now().year);
                Navigator.pop(context);
              },
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showPasscode());
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // title: const Text('Inventory Management',
          //     style: TextStyle(fontSize: 14)),
          actions: [
            Obx(() => FilterDateButton(
                  onPrevMonthPressed: () =>
                      _homeController.prevNextMonth(prev: true),
                  onMonthPressed: monthDialog,
                  onNextMonthPressed: () =>
                      _homeController.prevNextMonth(next: true),
                  date: _homeController.currentDate.value,
                )),
            Obx(() => _homeController.isTabOutActive.value
                ? IconButton(
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/chart');
                      Get.delete<ChartController>();
                    },
                    icon: const Icon(Icons.pie_chart),
                  )
                : const SizedBox())
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
                              enabled: false,
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
                              enabled: false,
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
                                  controller: distributorTextController,
                                  decoration: const InputDecoration(
                                      labelText: 'Distributor')),
                              suggestionsCallback: (pattern) {
                                // return CitiesService.getSuggestions(pattern);
                                return _homeController.getDistributor(pattern);
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
                                distributorTextController.text =
                                    suggestion.toString();
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
                              enabled: false,
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
                              suggestionsCallback: (pattern) async {
                                // return CitiesService.getSuggestions(pattern);
                                return await _homeController
                                    .getAuditor(pattern);
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
                                createdByTextController.text = suggestion.toString();
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
        // ---------------------------------------------------
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
