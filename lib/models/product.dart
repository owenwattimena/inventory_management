class Product{
  final int? id;
  final String? sku;
  final String? barcode;
  final String? name;
  final String? uom;
  final String? category;
  final int? stock;

  Product({this.id, this.sku, this.barcode, this.name, this.uom, this.category, this.stock});

  Product copyWith({int? id, String? sku, String? barcode, String? name, String? uom, String? category, int? stock})=>Product(
    id: id ?? this.id,
    sku: sku ?? this.sku,
    barcode: barcode ?? this.barcode,
    name: name ?? this.name,
    uom: uom ?? this.uom,
    category: category ?? this.category,
    stock: stock ?? this.stock,
  );
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