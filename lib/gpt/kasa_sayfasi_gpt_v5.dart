import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GotPOS UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 1),
      ),
      home: const POSScreen(),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String categoryId;
  final IconData icon;
  Product({
    required this.name,
    required this.price,
    required this.categoryId,
    required this.icon,
  });
}

class Category {
  final String id;
  final String name;
  final IconData icon;
  Category({required this.id, required this.name, required this.icon});
}

class OrderItem {
  final Product product;
  int quantity;
  OrderItem({required this.product, this.quantity = 1});
  double get total => product.price * quantity;
}

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});
  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Category> categories;
  late List<Product> allProducts;
  List<OrderItem> cart = [];

  @override
  void initState() {
    super.initState();
    categories = [
      Category(id: 'bev', name: 'İçecek', icon: Icons.local_drink),
      Category(id: 'food', name: 'Yemek', icon: Icons.restaurant),
      Category(id: 'dess', name: 'Tatlı', icon: Icons.cake),
      Category(id: 'fast', name: 'Fast Food', icon: Icons.fastfood),
    ];
    allProducts = [
      Product(name: 'Su', price: 10, categoryId: 'bev', icon: Icons.water_drop),
      Product(
        name: 'Cola',
        price: 45,
        categoryId: 'bev',
        icon: Icons.local_drink,
      ),
      Product(
        name: 'Pizza',
        price: 185,
        categoryId: 'food',
        icon: Icons.local_pizza,
      ),
      Product(
        name: 'Baklava',
        price: 120,
        categoryId: 'dess',
        icon: Icons.cake,
      ),
      Product(
        name: 'Hamburger',
        price: 130,
        categoryId: 'fast',
        icon: Icons.lunch_dining,
      ),
      // … diğer ürünler
    ];
    _tabController = TabController(length: categories.length, vsync: this);
  }

  double get cartTotal => cart.fold(0.0, (sum, item) => sum + item.total);

  void addToCart(Product p) {
    setState(() {
      final existing = cart.where((o) => o.product.name == p.name);
      if (existing.isNotEmpty) {
        existing.first.quantity++;
      } else {
        cart.add(OrderItem(product: p));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p.name} sepete eklendi'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void openCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            maxChildSize: 0.9,
            builder:
                (_, ctrl) => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child:
                      cart.isEmpty
                          ? const Center(child: Text('Sepetiniz boş'))
                          : Column(
                            children: [
                              Text(
                                'Sepet (${cart.length})',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ListView.builder(
                                  controller: ctrl,
                                  itemCount: cart.length,
                                  itemBuilder: (_, i) {
                                    final item = cart[i];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        child: Text('${item.quantity}'),
                                      ),
                                      title: Text(item.product.name),
                                      subtitle: Text(
                                        '${item.product.price.toStringAsFixed(2)} ₺',
                                      ),
                                      trailing: Text(
                                        '${item.total.toStringAsFixed(2)} ₺',
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Toplam:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${cartTotal.toStringAsFixed(2)} ₺',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GotPOS'),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs:
                categories
                    .map((c) => Tab(icon: Icon(c.icon), text: c.name))
                    .toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children:
              categories.map((cat) {
                final prods =
                    allProducts.where((p) => p.categoryId == cat.id).toList();
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: prods.length,
                  itemBuilder: (_, i) {
                    final p = prods[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => addToCart(p),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(p.icon, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                p.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('${p.price.toStringAsFixed(2)} ₺'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
        ),
        // Sidebar tamamen kalktı, Drawer yok
        bottomNavigationBar: GestureDetector(
          onTap: openCartSheet,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.indigo.shade600,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  'Sepet (${cart.length})',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                Text(
                  '${cartTotal.toStringAsFixed(2)} ₺',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: openCartSheet,
          child: const Icon(Icons.arrow_upward),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
