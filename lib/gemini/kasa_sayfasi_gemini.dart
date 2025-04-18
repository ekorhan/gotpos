import 'package:flutter/material.dart';

class KasaSayfasi extends StatelessWidget {
  const KasaSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Garson')),
      body: Row(
        children: [
          // Sol Menü
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[300],
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: <Widget>[
                  _menuButonu('Masa Değiştir', Icons.table_chart),
                  _menuButonu('Adisyon Ekle', Icons.add_shopping_cart),
                  _menuButonu('Adisyon Notu', Icons.note),
                  _menuButonu('Masa Notu', Icons.sticky_note_2),
                  _menuButonu('Müşteri Seç', Icons.person_search),
                  _menuButonu('Grup Seç', Icons.group),
                  _menuButonu('Adisyon Ayır', Icons.call_split),
                  _menuButonu('Ödeme Tipi', Icons.payment),
                  _menuButonu('Hesap Yaz', Icons.receipt_long),
                  _menuButonu('Ödeme', Icons.money),
                ],
              ),
            ),
          ),
          // Ana İçerik
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Ürün Arama
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
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
                  // Kategoriler ve Ürünler
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _kategoriButonu('Drinks'),
                            _kategoriButonu('Foods'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _urunButonu('Cola', '₺0.00'),
                            _urunButonu('Sprite', '₺0.00'),
                            _urunButonu('Fanta', '₺0.00'),
                            // Daha fazla ürün eklenebilir
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Masa Bilgisi ve Alt Butonlar
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Masa 1',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Yazdır'),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Kapat'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Nakit'),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Kredi Kartı'),
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
          // Sağ Klavye
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 3,
                children: <Widget>[
                  _klavyeButonu(','),
                  _klavyeButonu('0'),
                  _klavyeButonu('1'),
                  _klavyeButonu('2'),
                  _klavyeButonu('3'),
                  _klavyeButonu('4'),
                  _klavyeButonu('5'),
                  _klavyeButonu('6'),
                  _klavyeButonu('7'),
                  _klavyeButonu('8'),
                  _klavyeButonu('9'),
                  _klavyeButonu('C', backgroundColor: Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuButonu(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _kategoriButonu(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown[400],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16.0)),
      ),
    );
  }

  Widget _urunButonu(String text, String fiyat) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange[300],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(fontSize: 16.0)),
            Text(fiyat, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _klavyeButonu(String text, {Color? backgroundColor}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.grey[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
