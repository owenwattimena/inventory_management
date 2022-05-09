
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../repository/product_repository.dart';

class ProductController extends GetxController{
  Rx<List<Product>> listProduct = Rx<List<Product>>([]);
  Rx<PlatformFile> file = Rx<PlatformFile>(PlatformFile(name: '', size: 0));
  RxString dropdownValue = "All".obs;
  

  void getProducts() {
    ProductRepository.getProduct().then((value) {
      listProduct.value = value;
    });
  }
  Future<void> importFile() async{
    await ProductRepository.importFile(file.value);
    getProducts();
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