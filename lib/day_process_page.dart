import 'package:flutter/material.dart';
import 'table_page.dart';
import 'setting_page.dart';
import 'services.dart';

class DayProcessPage extends StatelessWidget {
  const DayProcessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GotPOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Poppins',
        primaryColor: Colors.indigo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const GunIslemleriEkrani(),
    );
  }
}

class GunIslemleri {
  final String acilis;
  final String kapanis;
  final String aciklama;
  final String durum;

  GunIslemleri({
    required this.acilis,
    required this.kapanis,
    required this.aciklama,
    required this.durum,
  });
}

class GunIslemleriEkrani extends StatefulWidget {
  const GunIslemleriEkrani({super.key});

  @override
  State<GunIslemleriEkrani> createState() => _GunIslemleriEkraniState();
}

class _GunIslemleriEkraniState extends State<GunIslemleriEkrani> {
  // Gün işlemleri listesi
  final List<GunIslemleri> islemler = [
    GunIslemleri(
      acilis: '19.04.2025 09:54:18',
      kapanis: '1.01.0001 00:00:00',
      aciklama: '0',
      durum: '',
    ),
    // Daha fazla veri eklenebilir
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        title: const Text(
          'GotPOS',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Yenileme işlemi
              setState(() {});
            },
            tooltip: 'Yenile',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Ayarlar sayfasına git
            },
            tooltip: 'Ayarlar',
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.indigo.shade800,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                color: Colors.indigo.shade900,
                child: const Row(
                  children: [
                    Icon(Icons.point_of_sale, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'GotPOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(4),
                  children: [
                    _buildDrawerItem(Icons.dashboard, 'Masalar', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TableSelection(),
                        ),
                      );
                    }),
                    const Divider(color: Colors.white24),
                    _buildDrawerItem(Icons.calendar_today, 'Gün İşlemleri', () {
                      // Zaten bu sayfadayız
                      Navigator.pop(context);
                    }),
                    const Divider(color: Colors.white24),
                    _buildDrawerItem(Icons.fastfood, 'Menü Yönetimi', () {}),
                    const Divider(color: Colors.white24),
                    _buildDrawerItem(Icons.receipt_long, 'Adisyonlar', () {}),
                    const Divider(color: Colors.white24),
                    _buildDrawerItem(Icons.person, 'Müşteriler', () {}),
                    const Divider(color: Colors.white24),
                    _buildDrawerItem(Icons.assessment, 'Raporlar', () {}),
                    const Divider(color: Colors.white24),
                    _buildDrawerItem(Icons.settings, 'Ayarlar', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Setting(
                                tableService: InMemoryTableService(),
                                productService: InMemoryProductService(),
                                stockService: InMemoryStockService(),
                              ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.indigo.shade900,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Column(
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
                              'Mehmet Yılmaz',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Çıkış işlemi
                        },
                        icon: const Icon(Icons.logout, size: 18),
                        label: const Text('Oturumu Kapat'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          // Sol taraf (tablo)
          Expanded(flex: 4, child: _buildTableSection()),
          // Sağ taraf (işlem butonları)
          Expanded(flex: 1, child: _buildActionButtons()),
        ],
      ),
    );
  }

  Widget _buildTableSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.indigo.shade900,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'GÜN İŞLEMLERİ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Tablo başlıkları
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo.shade900,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(flex: 1, child: _buildTableHeaderCell('AÇILIŞ')),
                Expanded(flex: 1, child: _buildTableHeaderCell('KAPANIŞ')),
                Expanded(flex: 1, child: _buildTableHeaderCell('AÇIKLAMA')),
                Expanded(flex: 1, child: _buildTableHeaderCell('DURUM')),
              ],
            ),
          ),
          // Tablo verileri
          Expanded(
            child: ListView.builder(
              itemCount: islemler.length,
              itemBuilder: (context, index) {
                final islem = islemler[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: _buildTableCell(islem.acilis)),
                      Expanded(flex: 1, child: _buildTableCell(islem.kapanis)),
                      Expanded(flex: 1, child: _buildTableCell(islem.aciklama)),
                      Expanded(flex: 1, child: _buildTableCell(islem.durum)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          _buildActionButton(
            'Gün Başı Yap',
            Icons.play_circle_outline,
            Colors.green,
            () {
              // Gün başı işlemi
            },
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            'Gün Sonu Yap',
            Icons.stop_circle_outlined,
            Colors.red,
            () {
              // Gün sonu işlemi
            },
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            'Kasaya para ekle',
            Icons.add_circle_outline,
            Colors.grey.shade600,
            () {
              // Para ekleme işlemi
            },
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            'Ayarlar',
            Icons.settings,
            Colors.grey.shade600,
            () {
              // Ayarlar sayfası
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
          label: Text(text, style: const TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 24),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      hoverColor: Colors.white.withOpacity(0.1),
    );
  }
}
