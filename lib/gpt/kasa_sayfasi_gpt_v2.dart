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
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Poppins',
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

  void onPrint() {
    debugPrint('Yazdırıldı');
  }

  void onCash() {
    debugPrint('Nakit ödeme seçildi');
  }

  void onCard() {
    debugPrint('Kartla ödeme seçildi');
  }

  void onClose() {
    debugPrint('Sipariş kapatıldı');
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final products = productData[selectedCategory]!;

    return Scaffold(
      appBar: AppBar(title: const Text('GoPOS')),
      body: Row(
        children: [
          if (isWide) SidebarWidget(),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                buildCategorySelector(),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 4 : 2,
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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 36,
                                  ),
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
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                children: [
                  const Text(
                    'Sepet',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
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
                                    backgroundColor:
                                        categoryColors[selectedCategory]!
                                            .withOpacity(0.3),
                                    child: Text('${item.quantity}'),
                                  ),
                                  title: Text(item.name),
                                  subtitle: Text(
                                    '${item.price.toStringAsFixed(2)} ₺',
                                  ),
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
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Toplam:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${total.toStringAsFixed(2)} ₺'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onPrint,
                          child: const Text('Yazdır'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onClose,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text('Kapat'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onCash,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Nakit'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onCard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                          ),
                          child: const Text('Kart'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children:
            productData.keys.map((category) {
              final isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
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
}

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.swap_horiz, 'label': 'Masa'},
      {'icon': Icons.receipt_long, 'label': 'Adisyon'},
      {'icon': Icons.note_add, 'label': 'Not'},
      {'icon': Icons.person, 'label': 'Müşteri'},
      {'icon': Icons.group, 'label': 'Grup'},
      {'icon': Icons.call_split, 'label': 'Ayır'},
      {'icon': Icons.payment, 'label': 'Ödeme'},
      {'icon': Icons.print, 'label': 'Yazdır'},
      {'icon': Icons.logout, 'label': 'Çıkış'},
    ];

    return Container(
      width: 160,
      color: Colors.indigo,
      child: Column(
        children: [
          const SizedBox(height: 16),
          for (var item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item['icon'], color: Colors.indigo),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['label'],
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
