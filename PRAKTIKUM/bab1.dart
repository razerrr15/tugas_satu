import 'dart:async';

enum Role { Admin, Customer }

class Product {
  final String name;
  double price;
  bool inStock;

  Product(this.name, this.price, this.inStock);

  @override
  String toString() =>
      '$name (\$${price.toStringAsFixed(2)}, inStock: $inStock)';
}

class ProductOutOfStockException implements Exception {
  final String msg;
  ProductOutOfStockException(this.msg);
  @override
  String toString() => 'ProductOutOfStockException: $msg';
}

class DuplicateProductException implements Exception {
  final String msg;
  DuplicateProductException(this.msg);
  @override
  String toString() => 'DuplicateProductException: $msg';
}

class User {
  final String name;
  final int age;
  Role? role;
  late List<Product>? products;

  User(this.name, this.age, [this.role]);

  void initProducts() => products = [];

  void viewProducts() {
    if (products == null || products!.isEmpty) {
      print('$name belum memiliki produk.');
    } else {
      print('\nProduk milik $name:');
      for (var p in products!) {
        print(' - $p');
      }
    }
  }
}

class AdminUser extends User {
  AdminUser(String name, int age) : super(name, age, Role.Admin);

  void addProduct(User target, Product p, Set<String> uniq) {
    try {
      if (!p.inStock)
        throw ProductOutOfStockException('Produk "${p.name}" tidak tersedia.');
      if (uniq.contains(p.name))
        throw DuplicateProductException('Produk "${p.name}" sudah ada.');
      target.products ??= [];
      target.products!.add(p);
      uniq.add(p.name);
      print('Admin $name menambah produk "${p.name}" ke ${target.name}.');
    } catch (e) {
      print('Gagal menambah produk: $e');
    }
  }

  void removeProduct(User target, String productName, Set<String> uniq) {
    if (target.products == null) return;
    int before = target.products!.length;
    target.products!.removeWhere((p) => p.name == productName);
    if (target.products!.length < before) {
      uniq.remove(productName);
      print('Admin $name menghapus "$productName" dari ${target.name}.');
    } else {
      print('Produk "$productName" tidak ditemukan.');
    }
  }
}

class CustomerUser extends User {
  CustomerUser(String name, int age) : super(name, age, Role.Customer);
}

Future<Product?> fetchProduct(String name, Map<String, Product> catalog) async {
  print('\nMengambil detail "$name" dari server...');
  await Future.delayed(Duration(seconds: 1));
  if (catalog.containsKey(name)) {
    print('Selesai mengambil detail "$name".');
    return catalog[name];
  }
  print('Produk "$name" tidak ditemukan.');
  return null;
}

void main() async {
  final catalog = {
    'Laptop Pro': Product('Laptop Pro', 1200, true),
    'Headphone X': Product('Headphone X', 150, true),
    'Smartphone Z': Product('Smartphone Z', 800, false),
  };

  final uniq = <String>{};
  final admin = AdminUser('Raihan', 25)..initProducts();
  final user = CustomerUser('Alya', 22)..initProducts();

  admin.addProduct(user, catalog['Laptop Pro']!, uniq);
  admin.addProduct(user, catalog['Smartphone Z']!, uniq);
  admin.addProduct(user, catalog['Laptop Pro']!, uniq);
  user.viewProducts();

  admin.addProduct(user, catalog['Headphone X']!, uniq);
  user.viewProducts();

  admin.removeProduct(user, 'Laptop Pro', uniq);
  user.viewProducts();

  final p = await fetchProduct('Headphone X', catalog);
  if (p != null) print('Detail produk diambil: $p');
}
