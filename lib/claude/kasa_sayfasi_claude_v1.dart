import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoPOS',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Poppins',
        brightness: Brightness.light,
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

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  final List<OrderItem> orderItems = [
    OrderItem(name: 'Cola', quantity: 1, price: 45.00),
    OrderItem(name: 'Balık', quantity: 1, price: 98.00),
  ];

  String selectedCategory = 'İçecek';

  // Color scheme
  final Color primaryColor = const Color(0xFF4F6CAD);
  final Color secondaryColor = const Color(0xFF7C90C8);
  final Color accentColor = const Color(0xFF9BA6BF);
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color textColor = const Color(0xFF2D3142);
  final Color cardColor = Colors.white;
  final Color warningColor = Colors.deepOrangeAccent;

  // Category colors
  final Map<String, Color> categoryColors = {
    'İçecek': const Color(0xFF64B5F6),
    'Yemekler': const Color(0xFF4CAF50),
    'Tatlılar': const Color(0xFFFFB74D),
  };

  // Product lists by category
  final Map<String, List<Product>> productsByCategory = {
    'İçecek': [
      Product(name: 'Cola', price: 45.00),
      Product(name: 'Su', price: 10.00),
      Product(name: 'Ayran', price: 20.00),
      Product(name: 'Çay', price: 15.00),
      Product(name: 'Kahve', price: 30.00),
      Product(name: 'Soda', price: 25.00),
      Product(name: 'Meyve Suyu', price: 35.00),
      Product(name: 'Milkshake', price: 55.00),
    ],
    'Yemekler': [
      Product(name: 'Pizza', price: 185.00),
      Product(name: 'Pizza Özel', price: 260.00),
      Product(name: 'Balık', price: 98.00),
      Product(name: 'Sebze', price: 140.00),
      Product(name: 'Et', price: 290.00),
      Product(name: 'Tavuk', price: 175.00),
      Product(name: 'Çorba', price: 85.50),
      Product(name: 'Salata', price: 95.00),
      Product(name: 'Makarna', price: 120.00),
    ],
    'Tatlılar': [
      Product(name: 'Baklava', price: 120.00),
      Product(name: 'Künefe', price: 150.00),
      Product(name: 'Sütlaç', price: 80.00),
      Product(name: 'Dondurma', price: 60.00),
      Product(name: 'Kazandibi', price: 90.00),
      Product(name: 'Cheesecake', price: 110.00),
    ],
  };

  double get totalAmount =>
      orderItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void redictToCreditCard() {
    print("redictToCreditCard: ");
    for (var element in orderItems) {
      print('${element.quantity} Adet ${element.name}');
    }
  }

  void addProductToOrder(Product product) {
    setState(() {
      // Check if product already exists in order
      int existingIndex = orderItems.indexWhere(
        (item) => item.name == product.name,
      );

      if (existingIndex != -1) {
        // Increment quantity if product already exists
        orderItems[existingIndex] = OrderItem(
          name: orderItems[existingIndex].name,
          quantity: orderItems[existingIndex].quantity + 1,
          price: orderItems[existingIndex].price,
        );
      } else {
        // Add new product to order
        orderItems.add(
          OrderItem(name: product.name, quantity: 1, price: product.price),
        );
      }
    });
  }

  void removeOrderItem(int index) {
    setState(() {
      if (orderItems[index].quantity > 1) {
        // Reduce quantity by 1
        orderItems[index] = OrderItem(
          name: orderItems[index].name,
          quantity: orderItems[index].quantity - 1,
          price: orderItems[index].price,
        );
      } else {
        // Remove item completely
        orderItems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: Row(
          children: [
            Image.network(
              'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 8),
            const Text('GoPOS'),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
        elevation: 0,
      ),
      body: Row(
        children: [
          // Left sidebar with options
          SidebarWidget(
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            accentColor: accentColor,
            textColor: Colors.white,
          ),

          // Center - Order list
          Expanded(
            flex: 2,
            child: Container(
              color: backgroundColor,
              child: Column(
                children: [
                  // Table info and search
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: cardColor,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.table_restaurant, color: primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              'Masa 2',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Aktif',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Search bar
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Ürün Ara',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: backgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Order header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Sipariş Detayı',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(Icons.more_vert, color: textColor),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  // Order items list
                  Expanded(
                    child:
                        orderItems.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 64,
                                    color: accentColor,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Sepetiniz boş',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: textColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Sağdaki menüden ürün ekleyebilirsiniz',
                                    style: TextStyle(color: accentColor),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: orderItems.length,
                              itemBuilder: (context, index) {
                                final item = orderItems[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color:
                                                categoryColors[selectedCategory]
                                                    ?.withOpacity(0.1) ??
                                                accentColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${item.quantity}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color:
                                                    categoryColors[selectedCategory] ??
                                                    primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                  color: textColor,
                                                ),
                                              ),
                                              Text(
                                                'Normal',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: accentColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${item.price.toStringAsFixed(2)} ₺',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () => removeOrderItem(index),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.delete_outline,
                                              color: Colors.red.shade400,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),

                  // Bottom part with total and payment options
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Price summary
                        Row(
                          children: [
                            Text(
                              'Ara Toplam',
                              style: TextStyle(color: accentColor),
                            ),
                            const Spacer(),
                            Text(
                              '${totalAmount.toStringAsFixed(2)} ₺',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'KDV (%8)',
                              style: TextStyle(color: accentColor),
                            ),
                            const Spacer(),
                            Text(
                              '${(totalAmount * 0.08).toStringAsFixed(2)} ₺',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(),
                        ),
                        Row(
                          children: [
                            Text(
                              'Toplam',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${(totalAmount * 1.08).toStringAsFixed(2)} ₺',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  side: BorderSide(color: primaryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Yazdır',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor: warningColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Kapat',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor: secondaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Nakit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => redictToCreditCard(),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Kart',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right sidebar with categories and products
          Expanded(
            flex: 3,
            child: Container(
              color: backgroundColor,
              child: Column(
                children: [
                  // Categories
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: cardColor,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (String category in [
                            'İçecek',
                            'Yemekler',
                            'Tatlılar',
                          ])
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ElevatedButton(
                                onPressed: () => selectCategory(category),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                      selectedCategory == category
                                          ? categoryColors[category]
                                          : categoryColors[category]
                                              ?.withOpacity(0.1),
                                  foregroundColor:
                                      selectedCategory == category
                                          ? Colors.white
                                          : categoryColors[category],
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Category title and info
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          selectedCategory,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColors[selectedCategory]
                                ?.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${productsByCategory[selectedCategory]?.length ?? 0} ürün',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: categoryColors[selectedCategory],
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {},
                          tooltip: 'Sırala',
                        ),
                        IconButton(
                          icon: const Icon(Icons.view_module),
                          onPressed: () {},
                          tooltip: 'Görünüm',
                        ),
                      ],
                    ),
                  ),

                  // Product grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1.1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount:
                          productsByCategory[selectedCategory]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final product =
                            productsByCategory[selectedCategory]![index];
                        return ProductCard(
                          name: product.name,
                          price: product.price,
                          color:
                              categoryColors[selectedCategory] ?? primaryColor,
                          onPressed: () => addProductToOrder(product),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({required this.name, required this.quantity, required this.price});
}

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

class SidebarWidget extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color textColor;

  const SidebarWidget({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: primaryColor,
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildSidebarItem(Icons.swap_horiz, 'Masa', isSelected: true),
          _buildSidebarItem(Icons.receipt_long, 'Adisyon'),
          _buildSidebarItem(Icons.note_add, 'Not'),
          _buildSidebarItem(Icons.person, 'Müşteri'),
          _buildSidebarItem(Icons.group, 'Grup'),
          _buildSidebarItem(Icons.call_split, 'Ayır'),
          _buildSidebarItem(Icons.payment, 'Ödeme'),
          _buildSidebarItem(Icons.print, 'Yazdır'),
          const Spacer(),
          _buildSidebarItem(Icons.logout, 'Çıkış'),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    IconData icon,
    String label, {
    bool isSelected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isSelected ? primaryColor : textColor),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: textColor, fontSize: 12)),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final Color color;
  final VoidCallback onPressed;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image or icon
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(_getIconForProduct(name), size: 40, color: color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${price.toStringAsFixed(2)} ₺',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForProduct(String productName) {
    switch (productName.toLowerCase()) {
      case 'cola':
      case 'su':
      case 'ayran':
      case 'soda':
      case 'meyve suyu':
      case 'milkshake':
        return Icons.local_drink;
      case 'çay':
      case 'kahve':
        return Icons.coffee;
      case 'pizza':
      case 'pizza özel':
        return Icons.local_pizza;
      case 'balık':
        return Icons.set_meal;
      case 'sebze':
      case 'salata':
        return Icons.eco;
      case 'et':
      case 'tavuk':
        return Icons.restaurant;
      case 'çorba':
      case 'makarna':
        return Icons.soup_kitchen;
      case 'baklava':
      case 'künefe':
      case 'sütlaç':
      case 'dondurma':
      case 'kazandibi':
      case 'cheesecake':
        return Icons.cake;
      default:
        return Icons.fastfood;
    }
  }
}
