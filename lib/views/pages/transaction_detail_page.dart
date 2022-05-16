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
                      : '${args.warehouse} - ${args.createdBy}',
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
          // ignore: prefer_const_constructors
          InkWell(
            onTap: _showImagePicker,
            child: Obx(() => Container(
                  color: Colors.grey[200],
                  child: transactionController.imagePath.value.isEmpty
                      ? Icon(Icons.supervised_user_circle_outlined,
                          size: 131, color: Colors.grey[400])
                      : Image.file(
                          File(transactionController.imagePath.value),
                          height: 165,
                        ),
                )),
          ),
          Obx(
            () => Column(
              children: transactionController.products.value
                  .map(
                    (product) => Slidable(
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
                        onLongPress: () => (args.status != TransactionStatus.finished) ?  _showProductDialog(
                            addProduct: false, product: product) : null,
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
                      if (await _showDeleteConfirm(args.transactionId!) == true) {
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
                  onPressed: () async {
                    if(await transactionController.setTransactionFinished(args.transactionId!, args.type!)){
                      Navigator.pop(context);
                    }else{
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                        content: Text('Error. Transaction not finished.'),
                      ));
                    }
                  },
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
                child: FloatingActionButton(
                  heroTag: "btn3",
                  onPressed: _showProductDialog,
                  child: const Icon(Icons.add),
                ),
              ),
            ])
          : const SizedBox(),
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
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose your picture'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Gallery'),
                  onPressed: () async {
                    // check status permission
                    if (!await transactionController.checkPermission()) return;
                    image =
                        await _picker.pickImage(source: ImageSource.gallery);

                    File? _file = await transactionController
                        .saveImage(File(image!.path));
                    if (_file != null) {
                      transactionController.imagePath.value = _file.path;
                    }
                    print(_file!.path);
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Camera'),
                  onPressed: () async {
                    // check status permission
                    if (!await transactionController.checkPermission()) return;
                    image = await _picker.pickImage(source: ImageSource.camera);
                    File? _file = await transactionController
                        .saveImage(File(image!.path));
                    if (_file != null) {
                      transactionController.imagePath.value = _file.path;
                    }
                    print(_file!.path);
                    Navigator.of(context).pop();
                  },
                ),
              ],
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
}
