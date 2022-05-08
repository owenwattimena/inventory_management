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
                  ? '${args.unit} - ${args.takeBy}'
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
        padding: (args.status == TransactionStatus.panding)
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
                      : Image.file(File(transactionController.imagePath.value), height: 165,),
                )),
          ),
          Obx(
            () => Column(
              children: transactionController.products.value
                  .map((product) => ProductTile(product: product))
                  .toList(),
            ),
          ),
          // ProductTile(product: args.product),
        ],
      ),
      floatingActionButton: (args.status == TransactionStatus.panding)
          ? Stack(fit: StackFit.expand, children: [
              Positioned(
                bottom: 0,
                left: 32,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () {},
                    child: Transform.rotate(
                        angle: math.pi / 4, child: const Icon(Icons.add)),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: (MediaQuery.of(context).size.width - 185) / 2,
                child: ElevatedButton(
                  onPressed: () {},
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
                    if (! await transactionController.checkPermission()) return;
                    image = await _picker.pickImage(source: ImageSource.gallery);

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
                    if (! await transactionController.checkPermission()) return;
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

  Future<void> _showProductDialog() async {
    final TextEditingController _typeAheadController = TextEditingController();
    final TextEditingController quantityController =
        TextEditingController(text: '0');
    late Product selectedProduct;
    List<Product> products = [];

    for (var i = 0; i < 100; i++) {
      products.add(Product(
        id: i,
        sku: 'SKU-$i',
        name: 'product $i',
        category: 'Category $i',
        uom: 'Unit $i',
        stock: i,
      ));
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
                      controller: _typeAheadController,
                      decoration:
                          const InputDecoration(labelText: 'Add Product')),
                  suggestionsCallback: (pattern) {
                    // return CitiesService.getSuggestions(pattern);
                    return products
                        .where((element) => element.name!.contains(pattern))
                        .toList();
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
              onPressed: () {
                if (selectedProduct.sku != null) {
                  transactionController.setTransaction = selectedProduct
                      .copyWith(stock: int.parse(quantityController.text));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
