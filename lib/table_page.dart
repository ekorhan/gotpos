import 'package:flutter/material.dart';
import 'cash_register_page.dart'; // POSScreen'i içeren dosyayı import ediyoruz
import 'day_process_page.dart'; // Masa sayfasını import ediyoruz

class TableSelection extends StatelessWidget {
  const TableSelection({super.key});

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
      home: const MasaSecmeEkrani(),
    );
  }
}

class MasaSecmeEkrani extends StatefulWidget {
  const MasaSecmeEkrani({super.key});

  @override
  State<MasaSecmeEkrani> createState() => _MasaSecmeEkraniState();
}

enum MasaDurumu { bos, dolu }

// Masa modeli
class Masa {
  final int id;
  final String ad;
  final MasaDurumu durum;

  Masa({required this.id, required this.ad, this.durum = MasaDurumu.bos});
}

class _MasaSecmeEkraniState extends State<MasaSecmeEkrani> {
  // Masa durumları için enum

  // Masaları tutan liste
  late List<Masa> masalar;

  @override
  void initState() {
    super.initState();
    // Masaları oluştur
    masalar = List.generate(
      32,
      (index) => Masa(
        id: index + 1,
        ad: 'Masa ${index + 1}',
        // Demo için rastgele durum atayalım
        durum: index % 5 == 0 ? MasaDurumu.dolu : MasaDurumu.bos,
      ),
    );
  }

  // Masa durumuna göre renk döndürür
  Color _getMasaRengi(MasaDurumu durum) {
    switch (durum) {
      case MasaDurumu.bos:
        return Colors.grey.shade600;
      case MasaDurumu.dolu:
        return Colors.indigo.shade900;
    }
  }

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
              setState(() {
                // Masaların durumunu güncelle (demo için)
                masalar =
                    masalar.map((masa) {
                      final random = DateTime.now().millisecond % 3;
                      return Masa(
                        id: masa.id,
                        ad: masa.ad,
                        durum: random == 0 ? MasaDurumu.bos : MasaDurumu.dolu,
                      );
                    }).toList();
              });
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DayProcessPage(),
                        ),
                      );
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
                    _buildDrawerItem(Icons.settings, 'Ayarlar', () {}),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Masalar',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade900,
                  ),
                ),
                Row(
                  children: [
                    _buildLegendItem('Boş', Colors.grey.shade600),
                    const SizedBox(width: 16),
                    _buildLegendItem('Dolu', Colors.indigo.shade900),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: masalar.length,
                itemBuilder: (context, index) {
                  final masa = masalar[index];
                  return _buildMasaCard(masa);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasaCard(Masa masa) {
    return InkWell(
      onTap: () {
        // Masa seçildiğinde kasa ekranına git
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const POSScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: _getMasaRengi(masa.durum),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Center(
          child: Text(
            masa.ad,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
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
