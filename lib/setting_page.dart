import 'package:flutter/material.dart';

/// Servis soyutlamaları (uygulama katmanında kullanılır)
abstract class TableService {
  Future<void> addTable(String name, int capacity);
}

abstract class ProductService {
  Future<void> addProduct(String name, double price);
}

abstract class StockService {
  Future<void> addStock(String productId, int quantity);
}

/// Yönetim sayfası: butonları daha görsel ve kullanışlı kartlar olarak sunuyoruz
class Setting extends StatelessWidget {
  final TableService tableService;
  final ProductService productService;
  final StockService stockService;

  const Setting({
    super.key,
    required this.tableService,
    required this.productService,
    required this.stockService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yönetim Paneli'),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 4 / 3,
          children: [
            _ActionCard(
              icon: Icons.table_bar,
              label: 'Masa Ekle',
              color: theme.colorScheme.primary,
              onTap: () => _showAddTableDialog(context),
            ),
            _ActionCard(
              icon: Icons.inventory_2,
              label: 'Ürün Gir',
              color: theme.colorScheme.primary,
              onTap: () => _showAddProductDialog(context),
            ),
            _ActionCard(
              icon: Icons.add_shopping_cart,
              label: 'Stok Gir',
              color: Colors.indigo.shade900,
              onTap: () => _showAddStockDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddTableDialog(BuildContext context) async {
    final result = await showDialog<_TableData>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddTableDialog(),
    );
    if (result != null) {
      await tableService.addTable(result.name, result.capacity);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Masa "${result.name}" eklendi.')));
    }
  }

  Future<void> _showAddProductDialog(BuildContext context) async {
    final result = await showDialog<_ProductData>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddProductDialog(),
    );
    if (result != null) {
      await productService.addProduct(result.name, result.price);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ürün "${result.name}" eklendi.')));
    }
  }

  Future<void> _showAddStockDialog(BuildContext context) async {
    final result = await showDialog<_StockData>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddStockDialog(),
    );
    if (result != null) {
      await stockService.addStock(result.productId, result.quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stok güncellendi: ${result.quantity} adet.')),
      );
    }
  }
}

/// Tek bir eylem kartı
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                radius: 32,
                child: Icon(icon, size: 48, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Data taşıyıcı sınıflar
class _TableData {
  final String name;
  final int capacity;
  _TableData(this.name, this.capacity);
}

class _ProductData {
  final String name;
  final double price;
  _ProductData(this.name, this.price);
}

class _StockData {
  final String productId;
  final int quantity;
  _StockData(this.productId, this.quantity);
}

// Dialoglar (Change etmeden bıraktık veya tasarım ihtiyaçlarına göre düzeltilir)

class AddTableDialog extends StatefulWidget {
  @override
  _AddTableDialogState createState() => _AddTableDialogState();
}

class _AddTableDialogState extends State<AddTableDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _capacity = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('Masa Ekle'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Masa Adı'),
              validator: (v) => v == null || v.isEmpty ? 'Gerekli' : null,
              onSaved: (v) => _name = v!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Kapasite'),
              keyboardType: TextInputType.number,
              initialValue: '1',
              validator: (v) {
                final n = int.tryParse(v ?? '');
                return n == null || n < 1 ? '1 veya daha fazla olmalı' : null;
              },
              onSaved: (v) => _capacity = int.parse(v!),
            ),
          ],
        ),
      ),
      actions: _buildDialogActions(context),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _price = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('Ürün Gir'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Ürün Adı'),
              validator: (v) => v == null || v.isEmpty ? 'Gerekli' : null,
              onSaved: (v) => _name = v!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Fiyat'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                final d = double.tryParse(v ?? '');
                return d == null || d <= 0 ? 'Pozitif sayı girin' : null;
              },
              onSaved: (v) => _price = double.parse(v!),
            ),
          ],
        ),
      ),
      actions: _buildDialogActions(context),
    );
  }
}

class AddStockDialog extends StatefulWidget {
  @override
  _AddStockDialogState createState() => _AddStockDialogState();
}

class _AddStockDialogState extends State<AddStockDialog> {
  final _formKey = GlobalKey<FormState>();
  String _selectedProduct = '';
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('Stok Gir'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              items:
                  ['Ürün A', 'Ürün B', 'Ürün C']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              decoration: const InputDecoration(labelText: 'Ürün Seç'),
              validator: (v) => v == null || v.isEmpty ? 'Ürün seçin' : null,
              onChanged: (v) => _selectedProduct = v!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Miktar'),
              keyboardType: TextInputType.number,
              initialValue: '1',
              validator: (v) {
                final n = int.tryParse(v ?? '');
                return n == null || n < 1 ? '1 veya daha fazla olmalı' : null;
              },
              onSaved: (v) => _quantity = int.parse(v!),
            ),
          ],
        ),
      ),
      actions: _buildDialogActions(context),
    );
  }
}

List<Widget> _buildDialogActions(BuildContext context) => [
  TextButton(
    onPressed: () => Navigator.of(context).pop(),
    child: const Text('İptal'),
  ),
  ElevatedButton(
    onPressed: () {
      final form = (context as Element).findAncestorStateOfType<FormState>();
      if (form != null && form.validate()) {
        form.save();
        Navigator.of(context).pop();
      }
    },
    child: const Text('Kaydet'),
  ),
];
