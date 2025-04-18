import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GotPOS Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
          secondary: Colors.amber,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFD),
        fontFamily: 'Inter',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo.shade900,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: const CardTheme(
          elevation: 1,
          shape: RoundedRectangleBorder(),
          margin: EdgeInsets.zero,
        ),
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
    this.icon = Icons.fastfood,
  });
}

class Category {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String categoryId;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.categoryId,
  });

  double get total => quantity * price;
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
  bool isProcessingPayment = false;
  String? paymentErrorMessage;
  bool isMobileLayout = false;
  bool isCartExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  void _initializeData() {
    categories = [
      Category(
        id: 'beverage',
        name: 'İçecek',
        color: Colors.blue.shade700,
        icon: Icons.local_drink,
      ),
      Category(
        id: 'food',
        name: 'Yemek',
        color: Colors.orange.shade700,
        icon: Icons.restaurant,
      ),
      Category(
        id: 'dessert',
        name: 'Tatlı',
        color: Colors.pink.shade400,
        icon: Icons.cake,
      ),
      Category(
        id: 'fast_food',
        name: 'Fast Food',
        color: Colors.green.shade700,
        icon: Icons.fastfood,
      ),
    ];

    allProducts = [
      Product(
        name: 'Su',
        price: 10.0,
        categoryId: 'beverage',
        icon: Icons.water_drop,
      ),
      Product(name: 'Cola', price: 45.0, categoryId: 'beverage'),
      Product(
        name: 'Pizza',
        price: 185.0,
        categoryId: 'food',
        icon: Icons.local_pizza,
      ),
      Product(name: 'Kebap', price: 150.0, categoryId: 'food'),
      Product(name: 'Baklava', price: 120.0, categoryId: 'dessert'),
      Product(name: 'Hamburger', price: 130.0, categoryId: 'fast_food'),
    ];
  }

  double get total => cart.fold(0, (sum, item) => sum + item.total);

  void addToCart(Product product) {
    HapticFeedback.lightImpact();
    setState(() {
      final index = cart.indexWhere((item) => item.name == product.name);
      if (index != -1) {
        cart[index] = OrderItem(
          name: cart[index].name,
          quantity: cart[index].quantity + 1,
          price: cart[index].price,
          categoryId: cart[index].categoryId,
        );
      } else {
        cart.add(
          OrderItem(
            name: product.name,
            quantity: 1,
            price: product.price,
            categoryId: product.categoryId,
          ),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} sepete eklendi'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _updateCartItemQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        cart.removeAt(index);
      } else {
        cart[index] = OrderItem(
          name: cart[index].name,
          quantity: newQuantity,
          price: cart[index].price,
          categoryId: cart[index].categoryId,
        );
      }
    });
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sepeti Temizle'),
            content: const Text(
              'Sepetteki tüm ürünler silinecek. Emin misiniz?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              FilledButton(
                onPressed: () {
                  setState(() => cart.clear());
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Temizle'),
              ),
            ],
          ),
    );
  }

  void _processPayment(String method) {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sepet boş, ödeme yapılamaz')),
      );
      return;
    }

    setState(() => isProcessingPayment = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isProcessingPayment = false;
        if (DateTime.now().millisecond % 5 == 0) {
          paymentErrorMessage = 'Ödeme başarısız. Lütfen tekrar deneyin.';
        } else {
          cart.clear();
          paymentErrorMessage = null;
          _showSuccessDialog(method);
        }
      });
    });
  }

  void _showSuccessDialog(String method) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Column(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Ödeme Başarılı',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ödeme Türü: $method'),
                Text('Toplam: ${total.toStringAsFixed(2)} ₺'),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tamam'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    isMobileLayout = screenSize.width < 600;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelColor: Colors.white70,
                  tabs:
                      categories
                          .map(
                            (category) => Tab(
                              child: Row(
                                children: [
                                  Icon(category.icon, size: 20),
                                  const SizedBox(width: 8),
                                  Text(category.name),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children:
              categories
                  .map((category) => _buildProductGrid(category))
                  .toList(),
        ),
        bottomSheet: isMobileLayout ? _buildMobileCart() : null,
      ),
    );
  }

  Widget _buildProductGrid(Category category) {
    final products =
        allProducts.where((p) => p.categoryId == category.id).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder:
          (context, index) => _ProductCard(
            product: products[index],
            category: category,
            onTap: () => addToCart(products[index]),
          ),
    );
  }

  Widget _buildMobileCart() {
    return Container(
      height: isCartExpanded ? 400 : 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16)],
      ),
      child: Column(
        children: [
          _buildCartHeader(),
          if (isCartExpanded) Expanded(child: _buildCartList()),
        ],
      ),
    );
  }

  Widget _buildCartHeader() {
    return InkWell(
      onTap: () => setState(() => isCartExpanded = !isCartExpanded),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Icon(isCartExpanded ? Icons.expand_less : Icons.expand_more),
            const SizedBox(width: 12),
            Text(
              'Sepet (${cart.length})',
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Text(
              '${total.toStringAsFixed(2)} ₺',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: cart.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder:
          (context, index) => _CartItem(
            item: cart[index],
            onUpdate: (qty) => _updateCartItemQuantity(index, qty),
          ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final Category category;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(product.icon, size: 36, color: category.color),
              const SizedBox(height: 12),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${product.price.toStringAsFixed(2)} ₺',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final OrderItem item;
  final Function(int) onUpdate;

  const _CartItem({required this.item, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => onUpdate(item.quantity - 1),
            ),
            Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onUpdate(item.quantity + 1),
            ),
          ],
        ),
        Text(
          '${item.total.toStringAsFixed(2)} ₺',
          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}
