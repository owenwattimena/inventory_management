import '../models/product.dart';

class ProductService{
  Future<List<Product>> getProduct({String? query}) async {
    return [Product()];
  }
}