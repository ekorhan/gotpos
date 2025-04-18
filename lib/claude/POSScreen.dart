import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoPOS',
      theme: ThemeData(primarySwatch: Colors.brown, fontFamily: 'Roboto'),
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

  double get totalAmount =>
      orderItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text('GoPOS'),
        actions: [
          IconButton(icon: const Icon(Icons.minimize), onPressed: () {}),
          IconButton(icon: const Icon(Icons.close), onPressed: () {}),
        ],
      ),
      body: Row(
        children: [
          // Left sidebar with options
          SidebarWidget(),

          // Center - Order list
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Ürün Ara',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),

                  // Order items list
                  Expanded(
                    child: ListView.builder(
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) {
                        final item = orderItems[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete_outline, color: Colors.grey),
                                Text('${item.quantity}'),
                              ],
                            ),
                            title: Text(item.name),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item.price.toStringAsFixed(2)),
                                Text(
                                  'Normal',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom part with total and payment options
                  Container(
                    color: const Color(0xFF3E3E3E),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Masa 2',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.receipt_outlined,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${totalAmount.toStringAsFixed(2)}TL',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Print and Close buttons
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: const Color(0xFF3E3E3E),
                                height: 50,
                                child: TextButton.icon(
                                  icon: const Icon(
                                    Icons.print,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Yazdır',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: const Color(0xFF3E3E3E),
                                height: 50,
                                child: TextButton(
                                  child: const Text(
                                    'Kapat',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Payment buttons
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                height: 50,
                                child: TextButton(
                                  child: const Text(
                                    'Nakit',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                height: 50,
                                child: TextButton(
                                  child: const Text(
                                    'Kredi Kartı',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Number pad
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            for (var i in [
                              ',',
                              '0',
                              '1',
                              '2',
                              '3',
                              '4',
                              '5',
                              '6',
                              '7',
                              '8',
                              '9',
                              'C',
                            ])
                              Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    i,
                                    style: const TextStyle(fontSize: 18),
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
            child: Column(
              children: [
                // Categories
                CategoryButton(
                  title: 'İçecek',
                  color: const Color(0xFF5D4B3F),
                  textColor: Colors.white,
                ),
                CategoryButton(
                  title: 'Yemekler',
                  color: const Color(0xFFF15A24),
                  textColor: Colors.white,
                ),
                CategoryButton(
                  title: 'Tatlılar',
                  color: const Color(0xFF5D4B3F),
                  textColor: Colors.white,
                ),

                // Product grid
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 6,
                    children: [
                      ProductButton(
                        name: 'Pizza',
                        price: '185.00',
                        color: Colors.red.shade400,
                      ),
                      ProductButton(
                        name: 'Pizza',
                        price: '260.00',
                        color: Colors.red.shade400,
                      ),
                      ProductButton(
                        name: 'Balık',
                        price: '98.00',
                        color: Colors.red.shade400,
                      ),
                      ProductButton(
                        name: 'Sebze',
                        price: '140.00',
                        color: Colors.red.shade400,
                      ),
                      ProductButton(
                        name: 'Et',
                        price: '290.00',
                        color: Colors.red.shade400,
                      ),
                      ProductButton(
                        name: 'Tavuk',
                        price: '175.00',
                        color: Colors.red.shade400,
                      ),
                      ProductButton(
                        name: 'Çorba',
                        price: '85.50',
                        color: Colors.red.shade400,
                      ),
                    ],
                  ),
                ),
              ],
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

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      color: const Color(0xFF3E3E3E),
      child: Column(
        children: [
          SidebarButton(title: 'Masa Değiştir', icon: Icons.swap_horiz),
          const Divider(color: Colors.grey, height: 1),
          SidebarButton(title: 'Adisyon Ekle', icon: Icons.playlist_add),
          const Divider(color: Colors.grey, height: 1),
          SidebarButton(title: 'Adisyon Notu', icon: Icons.note_add),
          const Divider(color: Colors.grey, height: 1),
          SidebarButton(title: 'Masa Notu', icon: Icons.edit_note),
          const Divider(color: Colors.grey, height: 1),
          SidebarButton(title: 'Müşteri Seç', icon: Icons.person),
          const Divider(color: Colors.grey, height: 1),
          SidebarButton(title: 'Grup Seç', icon: Icons.group),
          const Divider(color: Colors.grey, height: 1),
          SidebarButton(title: 'Adisyon Ayır', icon: Icons.call_split),
          const Divider(color: Colors.grey, height: 1),
          SidebarButton(title: 'Ödeme Tipi', icon: Icons.payment),
          const Divider(color: Colors.grey, height: 1),
          Container(
            color: Colors.red.shade700,
            child: SidebarButton(
              title: 'Hesap Yaz',
              icon: Icons.print,
              textColor: Colors.white,
            ),
          ),
          const Divider(color: Colors.grey, height: 1),
          Container(
            color: Colors.red.shade700,
            child: SidebarButton(
              title: 'Ödeme',
              icon: Icons.monetization_on,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? textColor;

  const SidebarButton({
    super.key,
    required this.title,
    required this.icon,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextButton.icon(
        icon: Icon(icon, color: textColor),
        label: Text(title, style: TextStyle(color: textColor)),
        onPressed: () {},
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;

  const CategoryButton({
    super.key,
    required this.title,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: color,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ProductButton extends StatelessWidget {
  final String name;
  final String price;
  final Color color;

  const ProductButton({
    super.key,
    required this.name,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            price,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
