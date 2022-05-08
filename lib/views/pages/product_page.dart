part of 'pages.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        actions: [
          IconButton(
            onPressed: _showExportDialog,
            icon: const Icon(Icons.upload),
          )
        ],
      ),
      // ignore: prefer_const_literals_to_create_immutables
      body: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              hintText: 'Search',
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/product-detail');
                  },
                  child: ProductTile(
                    product: products[0],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showImportDialog();
        },
        child: const Icon(Icons.add),
      ),
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
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
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
    List<String> division = [];
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
                    items: <String>['All', 'SKU', 'Category']
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
                                InputDecoration(labelText: productController.dropdownValue.value == 'SKU' ? 'SKU' : 'Category')),
                        suggestionsCallback: (pattern) {
                          // return CitiesService.getSuggestions(pattern);
                          return division
                              .where((element) => element.contains(pattern))
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
                      )
                    : const SizedBox()),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('IMPORT FILE'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
