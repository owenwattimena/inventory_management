part of 'pages.dart';

class TransactionDetailPage extends StatefulWidget {
  final Transaction transaction;
  const TransactionDetailPage(this.transaction, {Key? key}) : super(key: key);

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  final transactionController = Get.put(TransactionController());

  late Transaction args;
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  @override
  void initState() {
    super.initState();
    args = widget.transaction;
    transactionController.getTransaction(args.transactionId!);
    transactionController.imagePath.value = args.photo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(args.transactionId!,
                    style: primaryTextStyleBold.copyWith(
                        color: Colors.white, fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                    DateFormat('E dd-MM-yyyy').format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            args.createdAt! * 1000)),
                    style: primaryTextStyle.copyWith(color: Colors.white)),
              ],
            ),
            Text(
              args.type == TransactionType.out
                  ? '${args.division} - ${args.takeBy}'
                  : args.type == TransactionType.entry
                      ? '${args.distributor}'
                      : /*'${args.warehouse} - */ '${args.createdBy}',
              style: primaryTextStyle.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      body: ListView(
        // ignore: prefer_const_literals_to_create_immutables
        padding: (args.status == TransactionStatus.pending)
            ? const EdgeInsets.only(bottom: 80)
            : const EdgeInsets.all(0),
        children: [
          (args.type == TransactionType.out)
              ? Obx(
                  () => transactionController.imagePath.value == null ||
                          transactionController.imagePath.value == 'null'
                      ? (args.status == TransactionStatus.pending) ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text('Photo'),
                                IconButton(
                                    onPressed: _showImagePicker,
                                    icon: const Icon(Icons.camera_enhance))
                              ]),
                        ) : const SizedBox()
                      : Stack(
                          children: [
                            Container(
                              // color: Colors.grey[200],
                              color: Colors.white,
                              child: Center(
                                child: File(transactionController.imagePath.value?? '').existsSync() ? Image.file(
                                  File(transactionController.imagePath.value!),
                                  height: 165,
                                ) : const Padding(
                                  padding: EdgeInsets.symmetric(vertical:15.0),
                                  child: Text('No Image'),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: (args.status == TransactionStatus.pending) ? IconButton(
                                    onPressed: () async {
                                      if (await transactionController
                                          .setTransactionPhoto(
                                              args.transactionId!, null)) {
                                        await transactionController
                                            .deleteTransactionPhoto(
                                                transactionController
                                                    .imagePath.value!);
                                        transactionController.imagePath.value =
                                            null;
                                      }
                                    },
                                    icon: const Icon(Icons.close)) : const SizedBox(),
                                    )
                          ],
                        ),
                )
              : const SizedBox(),
          Container(
            color: Colors.grey[200],
            height: 12,
          ),
          Obx(
            () => Column(
              children: transactionController.products.value
                  .map(
                    (product) => Slidable(
                      enabled: args.status == TransactionStatus.pending,
                      key: Key(product.sku!),
                      direction: Axis.horizontal,
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,
                            onPressed: (_) async {
                              if (await transactionController
                                  .deleteTransactionProduct(
                                      args.transactionId!, product.sku!)) {
                                transactionController
                                    .getTransaction(args.transactionId!);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Success. Product deleted from transaction.'),
                                ));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Error. Product not deleted from transaction.'),
                                ));
                              }
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'DELETE',
                          ),
                        ],
                      ),
                      child: InkWell(
                        onLongPress: () =>
                            (args.status != TransactionStatus.finished)
                                ? _showProductDialog(
                                    addProduct: false, product: product)
                                : null,
                        child: ProductTile(product: product),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // ProductTile(product: args.product),
        ],
      ),
      floatingActionButton: (args.status == TransactionStatus.pending)
          ? Stack(fit: StackFit.expand, children: [
              Positioned(
                bottom: 0,
                left: 32,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () async {
                      if (await _showDeleteConfirm(args.transactionId!) ==
                          true) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Error. Transaction not deleted.'),
                        ));
                      }
                    },
                    child: Transform.rotate(
                        angle: math.pi / 4, child: const Icon(Icons.add)),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: (MediaQuery.of(context).size.width - 185) / 2,
                child: ElevatedButton(
                  onPressed: _showFinalConfirmDialog,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const SizedBox(
                    width: 185,
                    height: 56,
                    child: Center(child: Text('FINAL')),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: (args.type == TransactionType.out)
                    ? FloatingActionButton(
                        heroTag: "btn3",
                        onPressed: _showProductDialog,
                        child: const Icon(Icons.add),
                      )
                    : SpeedDial(
                        icon: Icons.add,
                        activeIcon: Icons.close,
                        children: [
                          SpeedDialChild(
                              child: const Icon(Icons.add),
                              label: 'New Transaction',
                              backgroundColor: Colors.blue,
                              onTap: _showProductDialog),
                          SpeedDialChild(
                              child: const Icon(Icons.download),
                              label: 'Import',
                              onTap: () => _showImportDialog(context)),
                        ],
                      ),
              ),
            ])
          : const SizedBox(),
    );
  }

  Future<void> _showFinalConfirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                const Text('This will finalize the transaction.'),
                const Text('This cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('FINALIZE'),
              onPressed: () async {
                if (await transactionController.setTransactionFinished(
                    args.transactionId!, args.type!)) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Error. Transaction not finished.'),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirm(String transactionID) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sure to delete this transaction?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            ElevatedButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            ElevatedButton(
              child: const Text('DELETE'),
              onPressed: () async {
                if (await transactionController
                    .deleteTransaction(transactionID)) {
                  if (transactionController.imagePath.value != null ||
                      transactionController.imagePath.value != 'null') {
                    await transactionController.deleteTransactionPhoto(
                        transactionController.imagePath.value!);
                  }
                  Navigator.pop(context, true);
                } else {
                  Navigator.pop(context, false);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showImagePicker() async {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 105, right: 16),
          child: Align(
            alignment: Alignment.topRight,
            child: DecoratedBox(
              position: DecorationPosition.background,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.5,
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                          child: Container(
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              child: Text(
                                'Gallery',
                                style: primaryTextStyle.copyWith(
                                    decoration: TextDecoration.none),
                                textAlign: TextAlign.left,
                              )),
                          onTap: () async {
                            if (!await transactionController.checkPermission()){
                              return;
                            }
                            image = await _picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 15);
                            if (image != null) {
                              // transactionController.imagePath.value =
                              // image!.path;

                              transactionController
                                  .uploadImage(File(image!.path), args.transactionId!)
                                  .then((val) async {
                                if (val != null) {
                                  if (await transactionController
                                      .setTransactionPhoto(
                                          args.transactionId!, val.path)) {
                                    transactionController.imagePath.value =
                                        val.path;
                                  } else {
                                    transactionController.imagePath.value =
                                        null;
                                  }
                                }
                              });
                            }
                            Navigator.of(context).pop();
                          }),
                      GestureDetector(
                          child: Container(
                              padding: const EdgeInsets.all(12),
                              width: double.infinity,
                              child: Text(
                                'Camera',
                                style: primaryTextStyle.copyWith(
                                    decoration: TextDecoration.none),
                                textAlign: TextAlign.left,
                              )),
                          onTap: () async {
                            // check status permission
                            if (!await transactionController.checkPermission())
                            {
                              return;
                            }
                            image = await _picker.pickImage(
                                source: ImageSource.camera, imageQuality: 15);
                            if (image != null) {
                              // transactionController.imagePath.value =
                              //     image!.path;
                              transactionController
                                  .uploadImage(File(image!.path), args.transactionId!)
                                  .then((val) async {
                                if (val != null) {
                                  if (await transactionController
                                      .setTransactionPhoto(
                                          args.transactionId!, val.path)) {
                                    transactionController.imagePath.value =
                                        val.path;
                                  } else {
                                    transactionController.imagePath.value =
                                        null;
                                  }
                                }
                              });
                            }
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showProductDialog(
      {bool addProduct = true, Product? product}) async {
    final TextEditingController _typeAheadController =
        TextEditingController(text: (product != null) ? product.name : '');
    final TextEditingController quantityController = TextEditingController(
        text: (product != null) ? product.stock.toString() : '0');
    late Product selectedProduct;

    if (product != null) {
      selectedProduct = product;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Product"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TypeAheadFormField(
                  hideOnLoading: true,
                  minCharsForSuggestions: 3,
                  textFieldConfiguration: TextFieldConfiguration(
                      enabled: addProduct,
                      controller: _typeAheadController,
                      decoration:
                          const InputDecoration(labelText: 'Add Product')),
                  suggestionsCallback: (pattern) {
                    // return CitiesService.getSuggestions(pattern);
                    return transactionController.searchProduct(pattern);
                  },
                  itemBuilder: (BuildContext context, Product suggestion) {
                    return ListTile(
                      title: Text(suggestion.name!),
                    );
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  onSuggestionSelected: (Product suggestion) {
                    _typeAheadController.text = suggestion.name!;
                    selectedProduct = suggestion;
                  },
                  noItemsFoundBuilder: (context) {
                    return const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'No Items Found',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    );
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter product';
                    }
                    return null;
                  },
                ),
                TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Quantity",
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                if (selectedProduct.sku != null) {
                  if (await transactionController.setTransaction(
                      args.transactionId!,
                      selectedProduct.copyWith(
                          stock: int.parse(quantityController.text)))) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Error. Product already in transcation'),
                    ));
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showImportDialog(BuildContext context) {
    final importFileController = TextEditingController();

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Import'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      await transactionController.openFilePicker();
                      importFileController.text =
                          transactionController.file.value.name;
                    },
                    child: TextField(
                      enabled: false,
                      controller: importFileController,
                      decoration: const InputDecoration(
                        hintText: 'Select file',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await transactionController
                          .importFile(args.transactionId!);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Import Success'),
                      ));
                      Navigator.of(context).pop();
                    },
                    child: const Text('IMPORT FILE'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
