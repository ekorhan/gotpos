import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GotPOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2D3142)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2D3142),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const POSScreen(),
    );
  }
}

class Product {
  final String name;
  final double price;
  Product({required this.name, required this.price});
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  OrderItem({required this.name, required this.quantity, required this.price});
}

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});
  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final Map<String, List<Product>> productData = {
    'İçecek': [
      Product(name: 'Cola', price: 45.0),
      Product(name: 'Su', price: 10.0),
    ],
    'Yemek': [
      Product(name: 'Pizza', price: 185.0),
      Product(name: 'Balık', price: 98.0),
    ],
    'Tatlı': [
      Product(name: 'Baklava', price: 120.0),
      Product(name: 'Sütlaç', price: 80.0),
    ],
  };

  final Map<String, Color> categoryColors = {
    'İçecek': Colors.lightBlue,
    'Yemek': Colors.green,
    'Tatlı': Colors.orange,
  };

  String selectedCategory = 'İçecek';
  List<OrderItem> cart = [];

  double get total =>
      cart.fold(0, (sum, item) => sum + item.quantity * item.price);

  void addToCart(Product product) {
    setState(() {
      final index = cart.indexWhere((item) => item.name == product.name);
      if (index != -1) {
        cart[index] = OrderItem(
          name: cart[index].name,
          quantity: cart[index].quantity + 1,
          price: cart[index].price,
        );
      } else {
        cart.add(
          OrderItem(name: product.name, quantity: 1, price: product.price),
        );
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      if (cart[index].quantity > 1) {
        cart[index] = OrderItem(
          name: cart[index].name,
          quantity: cart[index].quantity - 1,
          price: cart[index].price,
        );
      } else {
        cart.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = productData[selectedCategory]!;
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('GoPOS')),
      body:
          isWide
              ? Row(
                children: [
                  Expanded(child: buildProductArea(products)),
                  Expanded(child: buildCartArea()),
                ],
              )
              : Column(
                children: [
                  buildCategorySelector(),
                  Expanded(child: buildProductArea(products)),
                  const Divider(),
                  SizedBox(height: 200, child: buildCartArea()),
                ],
              ),
    );
  }

  Widget buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            productData.keys.map((category) {
              final isSelected = category == selectedCategory;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => setState(() => selectedCategory = category),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected
                            ? categoryColors[category]
                            : categoryColors[category]!.withOpacity(0.2),
                  ),
                  child: Text(category),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget buildProductArea(List<Product> products) {
    return Column(
      children: [
        buildCategorySelector(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => addToCart(product),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fastfood,
                          size: 40,
                          color: categoryColors[selectedCategory],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${product.price.toStringAsFixed(2)} ₺'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildCartArea() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Sepet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child:
              cart.isEmpty
                  ? const Center(child: Text('Sepet boş'))
                  : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: categoryColors[selectedCategory]!
                              .withOpacity(0.3),
                          child: Text('${item.quantity}'),
                        ),
                        title: Text(item.name),
                        subtitle: Text('${item.price.toStringAsFixed(2)} ₺'),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => removeFromCart(index),
                        ),
                      );
                    },
                  ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Toplam:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text('${total.toStringAsFixed(2)} ₺'),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed:
                    cart.isEmpty ? null : () => debugPrint("Ödeme ekranı"),
                child: const Text('Ödemeye Geç'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
