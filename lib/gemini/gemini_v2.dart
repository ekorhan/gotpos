import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Fiyat formatlaması için

// Uygulama Başlangıç Noktası
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Cihaz yönlendirmelerini belirle (POS sistemleri genellikle yatay kullanılır ama esneklik iyidir)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

// --- Uygulama Ana Widget'ı ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tutarlı bir tema tanımlayalım
    final baseTheme = ThemeData(
      fontFamily: 'Poppins', // Tutarlı font ailesi
      brightness: Brightness.light,
      colorSchemeSeed: Colors.indigo, // Ana renk paleti
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'GotPOS - Kafe Otomasyon', // Daha açıklayıcı başlık
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        // Tema üzerinde ince ayarlar
        scaffoldBackgroundColor: const Color(
          0xFFF8F9FA,
        ), // Biraz daha açık arka plan
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo.shade800, // Daha koyu AppBar
          foregroundColor: Colors.white,
          elevation: 1, // Hafif gölge
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: baseTheme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20, // Standart AppBar başlık boyutu
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 24,
          ), // Standart ikon boyutu
        ),
        cardTheme: CardTheme(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadius,
            ), // Standart köşe yuvarlaklığı
          ),
          color: Colors.white,
          surfaceTintColor:
              Colors.transparent, // Material 3 renk bindirmesini kaldır
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.buttonPaddingVertical,
              horizontal: AppConstants.buttonPaddingHorizontal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusSmall,
              ), // Daha küçük köşe yuvarlaklığı
            ),
            textStyle: baseTheme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600, // Biraz daha kalın yazı
            ),
            foregroundColor: Colors.white, // Varsayılan yazı rengi
            minimumSize: const Size(0, 50), // Yeterli yükseklik
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.buttonPaddingVertical,
              horizontal: AppConstants.buttonPaddingHorizontal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusSmall,
              ),
            ),
            side: BorderSide(color: baseTheme.colorScheme.primary),
            textStyle: baseTheme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            minimumSize: const Size(0, 50), // Yeterli yükseklik
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.buttonPaddingVertical,
              horizontal: AppConstants.buttonPaddingHorizontal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusSmall,
              ),
            ),
            textStyle: baseTheme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            minimumSize: const Size(0, 50), // Yeterli yükseklik
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.indigo.shade100,
          indicatorColor: Colors.amberAccent, // Daha belirgin indicator
          indicatorSize: TabBarIndicatorSize.tab, // Tüm tab'ı kaplasın
          dividerColor: Colors.transparent, // Ayırıcıyı kaldır
          labelStyle: baseTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16, // Daha okunaklı boyut
          ),
          unselectedLabelStyle: baseTheme.textTheme.titleMedium?.copyWith(
            fontSize: 16, // Aynı boyut, sadece renk farkı
          ),
        ),
        listTileTheme: ListTileThemeData(
          iconColor: baseTheme.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          elevation: 4,
        ),
      ),
      home: const POSScreen(),
    );
  }
}

// --- Sabit Değerler ---
class AppConstants {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double borderRadiusSmall = 8.0;
  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 16.0;

  static const double buttonPaddingVertical = 14.0; // Daha rahat tıklama alanı
  static const double buttonPaddingHorizontal = 20.0;

  static const double tabletBreakpoint =
      720.0; // Tablet/Desktop ayrımı için eşik değer
  static const double mobileCartHeightCollapsed =
      60.0; // Mobil kapalı sepet yüksekliği
}

// --- Veri Modelleri ---
class Product {
  final String name;
  final double price;
  final String categoryId;
  final IconData icon;

  Product({
    required this.name,
    required this.price,
    required this.categoryId,
    this.icon = Icons.fastfood, // Varsayılan ikon
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
  int quantity; // Değiştirilebilir olmalı
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

// --- POS Ana Ekranı ---
class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Category> _categories;
  late List<Product> _allProducts;
  final List<OrderItem> _cart = [];
  bool _isProcessingPayment = false;
  String? _paymentErrorMessage;
  bool _isCartExpandedOnMobile = false; // Mobil için sepet genişletme durumu

  // Para birimi formatlayıcı
  final _currencyFormatter = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
  );

  @override
  void initState() {
    super.initState();
    _initializeData(); // Verileri yükle
    _tabController = TabController(length: _categories.length, vsync: this);
    // Tab değişiminde state'i güncellemeye gerek yok, TabBarView kendi hallediyor
    // _tabController.addListener(() => setState(() {})); // Bu genellikle gereksizdir
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Verileri başlatma (Örnek Veriler)
  void _initializeData() {
    _categories = [
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
        color: Colors.red.shade600,
        icon: Icons.fastfood,
      ),
      Category(
        id: 'salad',
        name: 'Salata',
        color: Colors.green.shade600,
        icon: Icons.grass,
      ),
    ];

    _allProducts = [
      // Örnek ürünler... (kısa tutuldu)
      Product(
        name: 'Su',
        price: 10.0,
        categoryId: 'beverage',
        icon: Icons.water_drop,
      ),
      Product(
        name: 'Cola',
        price: 45.0,
        categoryId: 'beverage',
        icon: Icons.local_bar,
      ), // Farklı ikon
      Product(
        name: 'Türk Kahvesi',
        price: 40.0,
        categoryId: 'beverage',
        icon: Icons.coffee,
      ),
      Product(
        name: 'Çay',
        price: 15.0,
        categoryId: 'beverage',
        icon: Icons.emoji_food_beverage,
      ),
      Product(
        name: 'Pizza',
        price: 185.0,
        categoryId: 'food',
        icon: Icons.local_pizza,
      ),
      Product(
        name: 'Köfte',
        price: 120.0,
        categoryId: 'food',
        icon: Icons.kebab_dining,
      ), // Uygun ikon
      Product(
        name: 'Makarna',
        price: 80.0,
        categoryId: 'food',
        icon: Icons.ramen_dining,
      ), // Uygun ikon
      Product(
        name: 'Baklava',
        price: 120.0,
        categoryId: 'dessert',
        icon: Icons.bakery_dining,
      ), // Uygun ikon
      Product(
        name: 'Sütlaç',
        price: 80.0,
        categoryId: 'dessert',
        icon: Icons.rice_bowl,
      ), // Uygun ikon
      Product(
        name: 'Hamburger',
        price: 130.0,
        categoryId: 'fast_food',
        icon: Icons.lunch_dining,
      ),
      Product(
        name: 'Patates Kızartması',
        price: 50.0,
        categoryId: 'fast_food',
        icon: Icons.fastfood,
      ), // Varsayılan ikon
      Product(
        name: 'Sezar Salata',
        price: 95.0,
        categoryId: 'salad',
        icon: Icons.restaurant_menu,
      ), // Uygun ikon
      Product(
        name: 'Mevsim Salata',
        price: 75.0,
        categoryId: 'salad',
        icon: Icons.eco,
      ), // Uygun ikon
    ];
  }

  // Sepet Toplamı
  double get _totalCartAmount =>
      _cart.fold(0.0, (sum, item) => sum + item.total);

  // Ürünü Sepete Ekle
  void _addToCart(Product product) {
    HapticFeedback.mediumImpact(); // Biraz daha belirgin titreşim
    setState(() {
      final index = _cart.indexWhere((item) => item.name == product.name);
      if (index != -1) {
        _cart[index].quantity++; // Mevcut öğenin miktarını artır
      } else {
        _cart.add(
          OrderItem(
            name: product.name,
            quantity: 1,
            price: product.price,
            categoryId: product.categoryId,
          ),
        );
      }

      // Mobil düzen ve sepet kapalıysa ve ilk ürün ekleniyorsa sepeti aç
      final isMobile =
          MediaQuery.of(context).size.width < AppConstants.tabletBreakpoint;
      if (isMobile && !_isCartExpandedOnMobile && _cart.length == 1) {
        _isCartExpandedOnMobile = true;
      }
    });

    _showFeedbackSnackbar('${product.name} sepete eklendi.');
  }

  // Sepet Öğesi Miktarını Güncelle
  void _updateCartItemQuantity(int index, int change) {
    if (index < 0 || index >= _cart.length) return; // Geçersiz index kontrolü

    setState(() {
      final newQuantity = _cart[index].quantity + change;
      if (newQuantity <= 0) {
        // Miktar sıfır veya altına düşerse ürünü kaldır
        final removedItemName = _cart[index].name;
        _cart.removeAt(index);
        _showFeedbackSnackbar(
          '$removedItemName sepetten çıkarıldı.',
          actionLabel: 'Geri Al',
          onAction:
              () => _undoRemoveFromCart(
                index,
                _findProductByName(removedItemName)!,
              ), // Geri alma işlemi
        );
      } else {
        _cart[index].quantity = newQuantity;
      }
    });
  }

  // Sepetten ürün silmeyi geri alma (Snackbar Action için)
  void _undoRemoveFromCart(int index, Product product) {
    if (index < 0) return;
    setState(() {
      final item = OrderItem(
        name: product.name,
        quantity: 1, // Geri eklerken 1 adetle başla
        price: product.price,
        categoryId: product.categoryId,
      );
      if (index > _cart.length) {
        _cart.add(item); // Liste sonuna ekle (nadiren olmalı)
      } else {
        _cart.insert(index, item); // Orijinal pozisyonuna ekle
      }
    });
    _showFeedbackSnackbar('${product.name} sepete geri eklendi.');
  }

  // Ürün ismine göre ürünü bulma (yardımcı fonksiyon)
  Product? _findProductByName(String name) {
    try {
      return _allProducts.firstWhere((p) => p.name == name);
    } catch (e) {
      return null; // Ürün bulunamazsa
    }
  }

  // Sepeti Temizle (Onay Dialogu ile)
  void _clearCart() {
    if (_cart.isEmpty) return; // Boşsa işlem yapma

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
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _cart.clear();
                    _isCartExpandedOnMobile = false; // Mobil sepeti de kapat
                  });
                  Navigator.pop(context);
                  _showFeedbackSnackbar('Sepet temizlendi.');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Temizle'),
              ),
            ],
          ),
    );
  }

  // Ödeme İşlemi
  void _processPayment(String paymentMethod) {
    if (_cart.isEmpty) {
      _showFeedbackSnackbar('Sepet boş, ödeme yapılamaz.', isError: true);
      return;
    }

    setState(() {
      _isProcessingPayment = true;
      _paymentErrorMessage = null;
    });

    // Ödeme işlemi simülasyonu
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; // Widget ağaçtan kaldırıldıysa işlem yapma

      final isSuccess =
          DateTime.now().second % 4 != 0; // %75 başarı oranı simülasyonu

      setState(() {
        _isProcessingPayment = false;
        if (isSuccess) {
          _showPaymentSuccessDialog(paymentMethod, _totalCartAmount);
          _cart.clear(); // Başarılı ödeme sonrası sepeti temizle
          _isCartExpandedOnMobile = false; // Mobil sepeti kapat
        } else {
          _paymentErrorMessage =
              'Ödeme işlemi başarısız oldu. Lütfen tekrar deneyin veya farklı bir yöntem seçin.';
        }
      });
    });
  }

  // Başarılı Ödeme Dialogu
  void _showPaymentSuccessDialog(String paymentMethod, double totalAmount) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dışarı tıklayarak kapatmayı engelle
      builder:
          (context) => AlertDialog(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 56,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Text(
                  'Ödeme Başarılı',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogInfoRow('Ödeme Türü:', paymentMethod),
                _buildDialogInfoRow(
                  'Toplam Tutar:',
                  _currencyFormatter.format(totalAmount),
                ),
                _buildDialogInfoRow(
                  'Tarih:',
                  DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now()),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.only(
              bottom: AppConstants.paddingMedium,
              left: AppConstants.paddingMedium,
              right: AppConstants.paddingMedium,
            ),
            actions: [
              OutlinedButton.icon(
                icon: const Icon(Icons.print_outlined),
                label: const Text('Makbuz Yazdır'),
                onPressed: () {
                  Navigator.pop(context);
                  _printReceipt(paymentMethod, totalAmount);
                },
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              ElevatedButton(
                child: const Text('Tamam'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  // Dialog içindeki bilgi satırı için yardımcı widget
  Widget _buildDialogInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Makbuz Yazdırma Simülasyonu
  void _printReceipt(String paymentMethod, double totalAmount) {
    // Gerçek yazdırma işlemi burada entegre edilebilir.
    print('--- Makbuz Yazdırılıyor ---');
    print('Ödeme Türü: $paymentMethod');
    _cart.forEach(
      (item) => print(
        '${item.quantity}x ${item.name} - ${_currencyFormatter.format(item.total)}',
      ),
    );
    print('---------------------------');
    print('Toplam: ${_currencyFormatter.format(totalAmount)}');
    print('Tarih: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())}');
    print('---------------------------');
    _showFeedbackSnackbar('Makbuz yazdırma simülasyonu tamamlandı.');
  }

  // Geri Bildirim Snackbar'ı
  void _showFeedbackSnackbar(
    String message, {
    bool isError = false,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating, // Daha modern görünüm
        duration: Duration(
          seconds: onAction != null ? 5 : 2,
        ), // Aksiyon varsa daha uzun süre
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
        ),
        margin: const EdgeInsets.all(AppConstants.paddingSmall),
        action:
            actionLabel != null && onAction != null
                ? SnackBarAction(label: actionLabel, onPressed: onAction)
                : null,
      ),
    );
  }

  // --- Arayüz Oluşturma Metodları ---
  @override
  Widget build(BuildContext context) {
    // LayoutBuilder ile daha esnek ekran boyutu yönetimi
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTabletLayout =
            constraints.maxWidth >= AppConstants.tabletBreakpoint;

        return Scaffold(
          appBar: _buildAppBar(isTabletLayout),
          // Tablette sidebar direkt görünür, mobilde drawer olarak kullanılır
          drawer: isTabletLayout ? null : _buildSidebar(isDrawer: true),
          body: isTabletLayout ? _buildTabletLayout() : _buildMobileLayout(),
        );
      },
    );
  }

  // AppBar Widget'ı
  PreferredSizeWidget _buildAppBar(bool isTabletLayout) {
    return AppBar(
      // Tablette drawer ikonu yerine başka bir ikon veya boşluk olabilir
      leading:
          isTabletLayout
              ? Padding(
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                child: Icon(
                  Icons.point_of_sale,
                  size: 30,
                  color: Colors.amberAccent[100],
                ), // Logo/ikon
              )
              : null, // Mobilde varsayılan drawer ikonu kullanılır
      title:
          isTabletLayout
              ? const Text('GotPOS Satış Ekranı')
              : null, // Mobilde başlık yerine tablar daha önemli
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(
          kToolbarHeight,
        ), // TabBar yüksekliği
        child: TabBar(
          controller: _tabController,
          isScrollable: true, // Kategoriler sığmazsa kaydırılabilir
          tabAlignment: TabAlignment.start, // Soldan başlasın
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingSmall,
          ), // Kenar boşlukları
          tabs:
              _categories.map((category) {
                return Tab(
                  iconMargin: const EdgeInsets.only(
                    bottom: 4.0,
                  ), // İkon ve yazı arası boşluk
                  icon: Icon(category.icon, size: 22), // Biraz daha küçük ikon
                  text: category.name,
                );
              }).toList(),
        ),
      ),
      actions: [
        // Ortak işlemler (örneğin arama, filtreleme vs. eklenebilir)
        IconButton(
          tooltip: 'Ayarlar',
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            _showFeedbackSnackbar('Ayarlar açılıyor...');
            // TODO: Ayarlar sayfası navigasyonu
          },
        ),
        const SizedBox(width: AppConstants.paddingSmall),
      ],
    );
  }

  // Mobil Arayüz Düzeni
  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Ürünler Alanı
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children:
                _categories
                    .map((category) => _buildProductGrid(category))
                    .toList(),
          ),
        ),
        // Genişletilebilir Sepet Alanı
        _buildMobileCart(),
      ],
    );
  }

  // Tablet/Desktop Arayüz Düzeni
  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Sol Sidebar
        _buildSidebar(isDrawer: false), // Direkt görünür sidebar
        // Orta: Ürünler Alanı
        Expanded(
          flex: 5, // Ürünlere daha fazla alan
          child: TabBarView(
            controller: _tabController,
            children:
                _categories
                    .map((category) => _buildProductGrid(category))
                    .toList(),
          ),
        ),
        // Sağ: Sepet Alanı
        Expanded(
          flex: 3, // Sepet alanı
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                _buildCartHeader(), // Sepet başlığı
                Expanded(child: _buildCartContent()), // Sepet içeriği
                _buildPaymentSection(), // Ödeme bölümü
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Ürün Kartı Izgarası (Grid)
  Widget _buildProductGrid(Category category) {
    final productsInCategory =
        _allProducts.where((p) => p.categoryId == category.id).toList();

    if (productsInCategory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.no_food_outlined, size: 60, color: Colors.grey[400]),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Bu kategoride ürün bulunamadı.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    // Ekran genişliğine göre sütun sayısını hesapla
    final crossAxisCount = _calculateGridColumns();

    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: productsInCategory.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio:
            0.9, // Kart oranını ayarla (yükseklik biraz daha fazla)
        crossAxisSpacing: AppConstants.paddingMedium,
        mainAxisSpacing: AppConstants.paddingMedium,
      ),
      itemBuilder: (context, index) {
        final product = productsInCategory[index];
        return _buildProductCard(
          product,
          category,
        ); // Kategori bilgisi ile kartı oluştur
      },
    );
  }

  // Sütun Sayısını Hesaplama (Responsive)
  int _calculateGridColumns() {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 2; // Çok dar ekranlar
    if (width < 900) return 3; // Orta boy mobil / küçük tablet
    if (width < 1200) return 4; // Geniş tablet / küçük desktop
    return 5; // Geniş desktop
  }

  // Tek Bir Ürün Kartı Widget'ı
  Widget _buildProductCard(Product product, Category category) {
    return Card(
      clipBehavior:
          Clip.antiAlias, // İçeriğin kart sınırlarını aşmasını engelle
      elevation: 2, // Hafif yükseklik
      child: InkWell(
        onTap: () => _addToCart(product),
        splashColor: category.color.withOpacity(
          0.1,
        ), // Kategori rengine göre splash
        highlightColor: category.color.withOpacity(0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // İçeriği genişlet
          children: [
            // Ürün İkonu Alanı
            Container(
              height: 80, // Sabit yükseklik
              color: category.color.withOpacity(
                0.1,
              ), // Hafif kategori rengi arka planı
              child: Icon(product.icon, size: 40, color: category.color),
            ),
            // Ürün Bilgileri Alanı
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Dikeyde ortala
                  children: [
                    // Ürün Adı
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2, // En fazla 2 satır
                      overflow: TextOverflow.ellipsis, // Taşarsa ... ile göster
                    ),
                    const SizedBox(height: AppConstants.paddingSmall / 2),
                    // Fiyat
                    Text(
                      _currencyFormatter.format(
                        product.price,
                      ), // Formatlı fiyat
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            category.color, // Fiyatı kategori renginde göster
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mobil Cihazlar İçin Sepet Alanı Widget'ı
  Widget _buildMobileCart() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height:
          _isCartExpandedOnMobile
              ? MediaQuery.of(context).size.height *
                  0.5 // Açıkken ekranın yarısı
              : AppConstants
                  .mobileCartHeightCollapsed, // Kapalıyken sabit yükseklik
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.borderRadiusLarge),
          topRight: Radius.circular(AppConstants.borderRadiusLarge),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Sepet Başlık/Genişletme Çubuğu
          Material(
            color: Colors.transparent, // InkWell efekti için
            child: InkWell(
              onTap:
                  () => setState(
                    () => _isCartExpandedOnMobile = !_isCartExpandedOnMobile,
                  ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.borderRadiusLarge),
                topRight: Radius.circular(AppConstants.borderRadiusLarge),
              ),
              child: Container(
                height: AppConstants.mobileCartHeightCollapsed,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isCartExpandedOnMobile
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: AppConstants.paddingSmall),
                        Text(
                          'Sepet (${_cart.length} Ürün)',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      _currencyFormatter.format(_totalCartAmount),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Genişletilmiş Sepet İçeriği
          if (_isCartExpandedOnMobile)
            Expanded(
              child: Column(
                children: [
                  const Divider(height: 1),
                  Expanded(child: _buildCartContent()), // Sepet listesi
                  _buildPaymentSection(), // Ödeme bölümü (mobil için uyarlanmış olabilir)
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Sepet Başlığı (Tablet/Desktop için)
  Widget _buildCartHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sepet',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (_cart.isNotEmpty)
            Tooltip(
              message: 'Sepeti Temizle',
              child: IconButton(
                icon: Icon(
                  Icons.delete_sweep_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: _clearCart,
                visualDensity: VisualDensity.compact, // Daha sıkışık ikon
              ),
            ),
        ],
      ),
    );
  }

  // Sepet İçeriği (Liste)
  Widget _buildCartContent() {
    if (_cart.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart, size: 60, color: Colors.grey[400]),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                'Sepetiniz şu an boş.',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                'Ürün eklemek için sol menüden veya kategorilerden seçim yapın.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Alışverişe Başla'),
                onPressed: () {
                  _tabController.animateTo(0); // İlk kategoriye git
                  if (!_isCartExpandedOnMobile &&
                      MediaQuery.of(context).size.width <
                          AppConstants.tabletBreakpoint) {
                    // Eğer mobil ise ve sepet kapalıysa, sepeti kapatma animasyonu yapmaya gerek yok.
                  } else {
                    setState(
                      () => _isCartExpandedOnMobile = false,
                    ); // Mobil sepeti kapat (eğer açıksa)
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    // Ürünlerin olduğu sepet listesi
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      itemCount: _cart.length,
      separatorBuilder:
          (context, index) => const Divider(
            height: 1,
            indent: AppConstants.paddingMedium,
            endIndent: AppConstants.paddingMedium,
          ),
      itemBuilder: (context, index) {
        final item = _cart[index];
        final category = _categories.firstWhere(
          (c) => c.id == item.categoryId,
          orElse: () => _categories.first,
        ); // Kategori bulunamazsa varsayılan

        return Dismissible(
          key: ValueKey('cart_item_${item.name}_$index'), // Daha güvenilir key
          direction: DismissDirection.endToStart, // Sadece sağdan sola silme
          background: Container(
            color: Colors.red.shade700,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppConstants.paddingMedium),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Sil',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: AppConstants.paddingSmall),
                Icon(Icons.delete_outline, color: Colors.white),
              ],
            ),
          ),
          onDismissed: (direction) {
            final removedItemName = item.name;
            setState(() {
              _cart.removeAt(index);
            });
            _showFeedbackSnackbar(
              '$removedItemName sepetten çıkarıldı.',
              actionLabel: 'Geri Al',
              onAction:
                  () => _undoRemoveFromCart(
                    index,
                    _findProductByName(removedItemName)!,
                  ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingSmall,
              vertical: AppConstants.paddingSmall / 2,
            ),
            child: Row(
              children: [
                // Ürün Adı ve Fiyatı
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _currencyFormatter.format(item.price), // Birim fiyat
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                // Miktar Ayarlayıcı
                _buildQuantityAdjuster(index, item, category.color),
                const SizedBox(width: AppConstants.paddingMedium),
                // Toplam Fiyat
                SizedBox(
                  width: 80, // Sabit genişlik
                  child: Text(
                    _currencyFormatter.format(item.total),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.right, // Sağa yaslı
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Miktar Ayarlayıcı Widget'ı (+/- Butonları)
  Widget _buildQuantityAdjuster(
    int index,
    OrderItem item,
    Color categoryColor,
  ) {
    const double buttonSize = 36.0; // Buton boyutu (tap target için önemli)
    const iconSize = 18.0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Azaltma Butonu
          InkWell(
            onTap: () => _updateCartItemQuantity(index, -1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppConstants.borderRadiusSmall),
              bottomLeft: Radius.circular(AppConstants.borderRadiusSmall),
            ),
            child: SizedBox(
              width: buttonSize,
              height: buttonSize,
              child: Icon(
                Icons.remove,
                size: iconSize,
                color:
                    item.quantity > 1
                        ? categoryColor
                        : Colors.grey, // 1 ise pasif görünüm
              ),
            ),
          ),
          // Miktar Göstergesi
          Container(
            width: 40, // Genişlik
            height: buttonSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey[300]!),
                right: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Text(
              '${item.quantity}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          // Artırma Butonu
          InkWell(
            onTap: () => _updateCartItemQuantity(index, 1),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(AppConstants.borderRadiusSmall),
              bottomRight: Radius.circular(AppConstants.borderRadiusSmall),
            ),
            child: SizedBox(
              width: buttonSize,
              height: buttonSize,
              child: Icon(
                Icons.add,
                size: iconSize,
                color: categoryColor, // Her zaman aktif renk
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Ödeme Bölümü Widget'ı
  Widget _buildPaymentSection() {
    final bool canPay = _cart.isNotEmpty && !_isProcessingPayment;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color:
            Theme.of(
              context,
            ).scaffoldBackgroundColor, // Arka plandan biraz farklı
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hata Mesajı
          if (_paymentErrorMessage != null)
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusSmall,
                ),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: Text(
                      _paymentErrorMessage!,
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: Colors.red.shade700,
                    visualDensity: VisualDensity.compact,
                    onPressed:
                        () => setState(() => _paymentErrorMessage = null),
                  ),
                ],
              ),
            ),

          // Toplam Tutar
          Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Genel Toplam:',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  _currencyFormatter.format(_totalCartAmount),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // İşlem Butonları (Yazdır, İptal)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.print_outlined, size: 20),
                  label: const Text('Yazdır'),
                  onPressed:
                      canPay
                          ? () => _printReceipt('Önizleme', _totalCartAmount)
                          : null, // Ödeme öncesi yazdırma
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.delete_sweep_outlined, size: 20),
                  label: const Text('Sepeti Sil'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withOpacity(0.5),
                    ),
                  ),
                  onPressed: _cart.isNotEmpty ? _clearCart : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),

          // Ödeme Butonları veya Yükleniyor Göstergesi
          _isProcessingPayment
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppConstants.paddingMedium,
                  ),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                ),
              )
              : Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.money_outlined, size: 20),
                      label: const Text('Nakit Öde'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                      ),
                      onPressed: canPay ? () => _processPayment('Nakit') : null,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.credit_card_outlined, size: 20),
                      label: const Text('Kartla Öde'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed:
                          canPay ? () => _processPayment('Kredi Kartı') : null,
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }

  // Yan Menü (Sidebar/Drawer)
  Widget _buildSidebar({required bool isDrawer}) {
    final sidebarContent = Container(
      color: Colors.indigo.shade800, // Ana sidebar rengi
      child: Column(
        children: [
          // Başlık Alanı
          _buildSidebarHeader(),
          // Menü Öğeleri
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              children: [
                _buildSidebarSectionTitle('Masa & Sipariş'),
                _buildSidebarItem(
                  Icons.table_restaurant_outlined,
                  'Masa Değiştir',
                  () => _handleSidebarAction('Masa Değiştir'),
                  isDrawer: isDrawer,
                ),
                _buildSidebarItem(
                  Icons.add_box_outlined,
                  'Adisyon Ekle',
                  () => _handleSidebarAction('Adisyon Ekle'),
                  isDrawer: isDrawer,
                ),
                _buildSidebarItem(
                  Icons.note_alt_outlined,
                  'Adisyon Notu',
                  () => _handleSidebarAction('Adisyon Notu'),
                  isDrawer: isDrawer,
                ),
                _buildSidebarItem(
                  Icons.call_split_outlined,
                  'Adisyon Ayır',
                  () => _handleSidebarAction('Adisyon Ayır'),
                  isDrawer: isDrawer,
                ),
                _buildSidebarSectionTitle('Müşteri & Ödeme'),
                _buildSidebarItem(
                  Icons.person_outline,
                  'Müşteri Seç',
                  () => _handleSidebarAction('Müşteri Seç'),
                  isDrawer: isDrawer,
                ),
                _buildSidebarItem(
                  Icons.payments_outlined,
                  'Ödeme Tipi Seç',
                  () => _handleSidebarAction('Ödeme Tipi'),
                  isDrawer: isDrawer,
                ),
                _buildSidebarItem(
                  Icons.receipt_long_outlined,
                  'Hesap Yazdır',
                  () => _handleSidebarAction('Hesap Yazdır'),
                  isDrawer: isDrawer,
                ),
                _buildSidebarSectionTitle('Diğer'),
                _buildSidebarItem(
                  Icons.settings_outlined,
                  'Ayarlar',
                  () => _handleSidebarAction('Ayarlar'),
                  isDrawer: isDrawer,
                ),
                _buildSidebarItem(
                  Icons.help_outline,
                  'Yardım',
                  () => _handleSidebarAction('Yardım'),
                  isDrawer: isDrawer,
                ),
              ],
            ),
          ),
          // Alt Kullanıcı Alanı
          _buildSidebarFooter(),
        ],
      ),
    );

    // Eğer Drawer ise Drawer widget'ı içinde döndür, değilse SizedBox ile genişliği ayarla
    return isDrawer
        ? Drawer(child: sidebarContent)
        : SizedBox(
          width: 260, // Sabit sidebar genişliği
          child: Material(
            // Gölgelendirme ve diğer materyal efektleri için
            elevation: 2,
            child: sidebarContent,
          ),
        );
  }

  // Sidebar Başlık Alanı
  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.paddingMedium,
        AppConstants.paddingLarge + 20,
        AppConstants.paddingMedium,
        AppConstants.paddingMedium,
      ), // Üst boşluğu artır (AppBar altına gelmesi için)
      color: Colors.indigo.shade900, // Başlık arka planı
      child: Row(
        children: [
          Icon(
            Icons.point_of_sale_outlined,
            color: Colors.amberAccent[100],
            size: 28,
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Text(
            'GotPOS Menü',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar Bölüm Başlığı
  Widget _buildSidebarSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.paddingMedium,
        right: AppConstants.paddingMedium,
        top: AppConstants.paddingMedium,
        bottom: AppConstants.paddingSmall / 2,
      ),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white.withOpacity(0.6),
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8, // Harf aralığı
        ),
      ),
    );
  }

  // Tek bir Sidebar Menü Öğesi
  Widget _buildSidebarItem(
    IconData icon,
    String label,
    VoidCallback onTap, {
    required bool isDrawer,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ), // Biraz daha küçük font
      ),
      onTap: () {
        if (isDrawer) {
          Navigator.pop(context); // Drawer ise kapat
        }
        onTap(); // Verilen aksiyonu çalıştır
      },
      dense: true, // Daha kompakt yapı
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall / 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
      ),
      hoverColor: Colors.white.withOpacity(
        0.1,
      ), // Fare üzerine gelince hafif renk değişimi
      splashColor: Colors.white.withOpacity(0.05),
    );
  }

  // Sidebar Alt Kullanıcı Alanı
  Widget _buildSidebarFooter() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      color: Colors.indigo.shade900, // Alt bölüm arka planı
      child: Column(
        children: [
          // Kullanıcı Bilgisi
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.person_outline, color: Colors.white),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                // İsmin taşmasını engelle
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kasiyer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Mehmet Yılmaz', // Örnek Kullanıcı
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis, // Taşarsa ...
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          // Oturumu Kapat Butonu
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Oturumu Kapat'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white.withOpacity(0.8),
                side: BorderSide(color: Colors.white.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingSmall,
                ), // Daha küçük dikey padding
              ),
              onPressed: () {
                // TODO: Oturum kapatma işlemini ekle
                _showFeedbackSnackbar('Oturum kapatılıyor...');
              },
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar Aksiyonlarını Yönetme (Örnek)
  void _handleSidebarAction(String action) {
    _showFeedbackSnackbar('$action seçildi.');
    // TODO: İlgili aksiyonun işlevselliğini ekle (örn: sayfa değişimi, dialog gösterme)
  }
}
