import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../models/product.dart';
import '../repository/product_repository.dart';

class ProductController extends GetxController {
  Rx<List<Product>> listProduct = Rx<List<Product>>([]);
  Rx<PlatformFile> file = Rx<PlatformFile>(PlatformFile(name: '', size: 0));
  RxString dropdownValue = "All".obs;

  void getProducts({String? query}) {
    ProductRepository.getProduct(query: query).then((value) {
      listProduct.update((val) {
        listProduct.value = value;
      });
    });
  }

  Future<bool> addProduct(Product product) async {
    final result = await ProductRepository.addProduct(product);
    return result;
  }

  Future<bool> deleteProduct(String sku) async {
    final result = await ProductRepository.deleteProduct(sku);
    return result;
  }

  Future<List<String>> getCategory(String query) async {
    return await ProductRepository.getCategory(query:query);
  }

  Future<List<String>> getUom(String query) async {
    return await ProductRepository.getUom(query);
  }

  Future<void> importFile() async {
    await ProductRepository.importFile(file.value);
    getProducts();
  }

  Future<void> exportProduct({String? category}) async {
    String _share;
    if (dropdownValue.value == 'All') {
      _share = await ProductRepository.exportProduct();
    } else {
      _share = await ProductRepository.exportProduct(category: category);
    }
    Share.shareFiles([
      _share
    ]);
  }

  Future<void> openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file.value = result.files.first;
    } else {
      // User canceled the picker
    }
  }
}
