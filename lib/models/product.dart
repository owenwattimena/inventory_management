import 'package:excel/excel.dart';

class Product {
  final int? id;
  final String? sku;
  final String? barcode;
  final String? name;
  final String? uom;
  final String? category;
  final int? stock;
  final int? price;

  Product(
      {this.id,
      this.sku,
      this.barcode,
      this.name,
      this.uom,
      this.category,
      this.stock,
      this.price});

  factory Product.fromMapObject(Map<String, dynamic> json) => Product(
        id: json['id'],
        sku: json['sku'],
        name: json['name'],
        barcode: json['barcode'],
        uom: json['uom'],
        category: json['category'],
        price: json['price'],
      );

  Product copyWith(
          {int? id,
          String? sku,
          String? barcode,
          String? name,
          String? uom,
          String? category,
          int? stock,
          int? price}) =>
      Product(
        id: id ?? this.id,
        sku: sku ?? this.sku,
        barcode: barcode ?? this.barcode,
        name: name ?? this.name,
        uom: uom ?? this.uom,
        category: category ?? this.category,
        stock: stock ?? this.stock,
        price: price ?? this.price,
      );

  factory Product.fromArrayData(List array) {
    return Product(
        // id: id,
        sku: array[0].toString(),
        barcode: array[1].toString(),
        name: array[2].toString(),
        uom: array[3].toString(),
        category: array[4].toString(),
        price: array[5] is String
            ? int.parse(array[5])
            : (array[5] is double
                ? array[5].round()
                : array[5]),
      );
  }
  factory Product.fromArray(List<Data?> array, int id) {
    return Product(
        // id: id,
        sku: array[0]?.value,
        barcode: array[1]?.value,
        name: array[2]?.value,
        uom: array[3]?.value,
        category: array[4]?.value,
        price: array[5]?.value is String
            ? int.parse(array[5]?.value)
            : (array[5]?.value is double
                ? array[5]?.value.round()
                : array[5]?.value),
      );
  }
}

List<Product> products = [
  Product(
    id: 1,
    sku: 'ATK001',
    barcode: '1234567890123',
    name: 'Alas Mouse',
    uom: 'Pcs',
    category: 'Alat Tulis Kantor',
    stock: 15,
  ),
  Product(
    id: 2,
    sku: 'ATK002',
    barcode: '1234567890123',
    name: 'Alas Mouse',
    uom: 'Pcs',
    category: 'Alat Tulis Kantor',
    stock: 15,
  ),
  Product(
    id: 3,
    sku: 'ATK003',
    barcode: '1234567890123',
    name: 'Alas Mouse',
    uom: 'Pcs',
    category: 'Alat Tulis Kantor',
    stock: 15,
  ),
];
