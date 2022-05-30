part of 'pages.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final productController = Get.put(ProductController());

  @override
  initState() {
    super.initState();
    productController.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        actions: [
          // IconButton(
          //   onPressed: _showExportDialog,
          //   icon: const Icon(Icons.upload),
          // ),
          PopupMenuButton<String>(
            onSelected: (_) => _showExportDialog(),
            itemBuilder: (BuildContext context) {
              return {'Export'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      // ignore: prefer_const_literals_to_create_immutables
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              hintText: 'Search',
            ),
            onChanged: (value) => productController.getProducts(query: value),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: productController.listProduct.value.length,
                itemBuilder: (context, index) => Slidable(
                  key: Key(productController.listProduct.value[index].sku!),
                      direction: Axis.horizontal,
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,
                            onPressed: (_) async {
                              if (await productController
                                  .deleteProduct(productController.listProduct.value[index].sku!)) {
                                
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Success. Product deleted successfully.'),
                                ));
                                productController.getProducts();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Error. The product has a relationship in the transaction.'),
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
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, '/product-detail',
                          arguments: productController.listProduct.value[index]);
                      Get.delete<ProductTransactionController>();
                    },
                    child: ProductTile(
                      product: productController.listProduct.value[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.add),
              label: 'New Product',
              backgroundColor: Colors.blue,
              onTap: _showCreateProductDialog),
          SpeedDialChild(
              child: const Icon(Icons.download),
              label: 'Import',
              onTap: _showImportDialog),
        ],
      ),
    );
  }

  Future<void> _showCreateProductDialog() async {
    final formGlobalKey = GlobalKey<FormState>();
    final skuTextController = TextEditingController();
    final nameTextController = TextEditingController();
    final barcodeTextController = TextEditingController();
    final categoryTextController = TextEditingController();
    final uomTextController = TextEditingController();
    final priceTextController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Product'),
          content: SingleChildScrollView(
            child: Form(
              key: formGlobalKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: skuTextController,
                    decoration: const InputDecoration(
                      labelText: 'SKU',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter SKU';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: nameTextController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter name of product';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: barcodeTextController,
                    decoration: const InputDecoration(
                      labelText: 'Barcode',
                    ),
                  ),
                  TypeAheadFormField(
                    hideOnLoading: true,
                    minCharsForSuggestions: 3,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: categoryTextController,
                        decoration:
                            const InputDecoration(labelText: 'Category')),
                    suggestionsCallback: (pattern) {
                      return productController.getCategory(pattern);
                    },
                    itemBuilder: (BuildContext context, String suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    onSuggestionSelected: (String suggestion) {
                      categoryTextController.text = suggestion;
                    },
                    noItemsFoundBuilder: (context) {
                      return const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'No Category Found',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      );
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter category';
                      }
                      return null;
                    },
                  ),
                  TypeAheadFormField(
                    hideOnLoading: true,
                    minCharsForSuggestions: 3,
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: uomTextController,
                        decoration: const InputDecoration(labelText: 'UOM')),
                    suggestionsCallback: (pattern) {
                      return productController.getUom(pattern);
                    },
                    itemBuilder: (BuildContext context, String suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    onSuggestionSelected: (String suggestion) {
                      uomTextController.text = suggestion;
                    },
                    noItemsFoundBuilder: (context) {
                      return const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'No UOM Found',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      );
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter UOM';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: priceTextController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      if (formGlobalKey.currentState!.validate()) {
                        final product = Product(
                          sku: skuTextController.text,
                          name: nameTextController.text,
                          barcode: barcodeTextController.text.isEmpty
                              ? null
                              : barcodeTextController.text,
                          category: categoryTextController.text,
                          uom: uomTextController.text,
                          price: int.parse(priceTextController.text),
                        );
                        if (await productController.addProduct(product)) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Add Product Success'),
                          ));
                          productController.getProducts();
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'Add Product Failed. Product with this SKU or Barcode already exist'),
                          ));
                        }
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('SAVE'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showImportDialog() async {
    final importFileController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Import'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    await productController.openFilePicker();
                    importFileController.text =
                        productController.file.value.name;
                  },
                  child: TextField(
                    enabled: false,
                    controller: importFileController,
                    decoration: const InputDecoration(
                      hintText: 'Select File',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (importFileController.text.isNotEmpty) {
                      await productController.importFile();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Import Success'),
                      ));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please select the file first.'),
                      ));
                    }
                  },
                  child: const Text('IMPORT FILE'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showExportDialog() async {
    final exportFileController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Obx(
                  () => DropdownButton(
                    isExpanded: true,
                    value: productController.dropdownValue.value,
                    items: <String>['All', 'Category']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? val) {
                      productController.dropdownValue.value = val!;
                    },
                  ),
                ),
                Obx(() => productController.dropdownValue.value != 'All'
                    ? TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                            controller: exportFileController,
                            decoration:
                                const InputDecoration(labelText: 'Category')),
                        suggestionsCallback: (pattern) {
                          // return CitiesService.getSuggestions(pattern);
                          return productController.getCategory(pattern);
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
                          exportFileController.text = suggestion.toString();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter category';
                          }
                          return null;
                        },
                      )
                    : const SizedBox()),
                ElevatedButton(
                  onPressed: () async => await productController.exportProduct(
                      category: exportFileController.text),
                  child: const Text('EXPORT'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
