import 'package:file_picker/file_picker.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductRepository {
  
  static Future<List<Product>> getProduct({String? query}) async {
    final productService = ProductService();
    return await productService.getProduct(query: query);
  }
  
  static Future<void> importFile(PlatformFile  file) async {
    
  }
}