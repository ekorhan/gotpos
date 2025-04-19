import 'dart:async';
import 'setting_page.dart'; // TableService, ProductService, StockService soyutları burada

class InMemoryTableService implements TableService {
  final List<Map<String, dynamic>> _tables = [];
  @override
  Future<void> addTable(String name, int capacity) async {
    // Gerçek veri tabanına bağlanmak yerine, basit listeye ekleyelim
    _tables.add({'name': name, 'capacity': capacity});
    await Future.delayed(const Duration(milliseconds: 200));
    print('Masa eklendi: $name, kapasite: $capacity');
  }
}

class InMemoryProductService implements ProductService {
  final List<Map<String, dynamic>> _products = [];
  @override
  Future<void> addProduct(String name, double price) async {
    _products.add({'name': name, 'price': price});
    await Future.delayed(const Duration(milliseconds: 200));
    print('Ürün eklendi: $name, fiyat: $price');
  }
}

class InMemoryStockService implements StockService {
  final Map<String, int> _stock = {};
  @override
  Future<void> addStock(String productId, int quantity) async {
    _stock[productId] = (_stock[productId] ?? 0) + quantity;
    await Future.delayed(const Duration(milliseconds: 200));
    print('Stok güncellendi: $productId → ${_stock[productId]}');
  }
}
