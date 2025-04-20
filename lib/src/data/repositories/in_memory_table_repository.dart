// src/data/repositories/in_memory_table_repository.dart
import 'dart:math';
import '../../domain/entities/table_info.dart';
import '../../domain/repositories/table_repository.dart';

class InMemoryTableRepository implements TableRepository {
  late List<TableInfo> _tables;

  InMemoryTableRepository() {
    _tables = List.generate(
      32, // Başlangıçta 32 masa
      (index) => TableInfo(
        id: index + 1,
        name: 'Masa ${index + 1}',
        capacity: 4, // Varsayılan kapasite
        // Demo için rastgele durum
        status:
            Random().nextInt(5) == 0 ? TableStatus.occupied : TableStatus.empty,
      ),
    );
  }

  @override
  Future<List<TableInfo>> getTables() async {
    await Future.delayed(const Duration(milliseconds: 80)); // Simülasyon
    // Yenileme demo mantığını buraya taşıyabiliriz veya UI'da bırakabiliriz
    // _updateRandomStatus(); // Demo için durumları rastgele güncelle
    return List.unmodifiable(_tables);
  }
}
