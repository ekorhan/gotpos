// src/data/repositories/in_memory_day_process_repository.dart
import '../../domain/entities/day_process_info.dart';
import '../../domain/repositories/day_process_repository.dart';

class InMemoryDayProcessRepository implements DayProcessRepository {
  final List<DayProcessInfo> _processes = [
    // Başlangıç mock verisi
    DayProcessInfo(
      openingTime: '26.04.2025 23:11',
      closingTime: '00.00.0000 00:00',
      description: '12 İşlem',
      status: 'Açık',
    ),
    DayProcessInfo(
      openingTime: '25.04.2025 23:11',
      closingTime: '26.04.2025 09:24',
      description: '248 İşlem',
      status: 'Kapalı',
    ),
    DayProcessInfo(
      openingTime: '24.04.2025 23:11',
      closingTime: '25.04.2025 09:24',
      description: '198 İşlem',
      status: 'Kapalı',
    ),
    DayProcessInfo(
      openingTime: '22.04.2025 23:11',
      closingTime: '23.04.2025 09:24',
      description: '72 İşlem',
      status: 'Kapalı',
    ),
    DayProcessInfo(
      openingTime: '21.04.2025 23:11',
      closingTime: '22.04.2025 09:24',
      description: '163 İşlem',
      status: 'Kapalı',
    ),
    DayProcessInfo(
      openingTime: '20.04.2025 23:11',
      closingTime: '21.04.2025 09:24',
      description: '91 İşlem',
      status: 'Kapalı',
    ),
    DayProcessInfo(
      openingTime: '19.04.2025 23:11',
      closingTime: '20.04.2025 09:24',
      description: '98 İşlem',
      status: 'Kapalı',
    ),
    DayProcessInfo(
      openingTime: '23.04.2025 23:11',
      closingTime: '24.04.2025 09:24',
      description: '85 İşlem',
      status: 'Kapalı',
    ),
  ];

  @override
  Future<List<DayProcessInfo>> getDayProcesses() async {
    await Future.delayed(const Duration(milliseconds: 50)); // Simülasyon
    return List.unmodifiable(_processes); // Listenin kopyasını döndür
  }

  @override
  Future<void> startDay() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Yeni bir gün işlemi ekle veya mevcut olanı güncelle
    print('[InMemoryDayProcessRepository] Gün başı yapıldı.');
    // _processes.add(...); // Gerçek implementasyon
  }

  @override
  Future<void> endDay() async {
    await Future.delayed(const Duration(milliseconds: 200));
    print('[InMemoryDayProcessRepository] Gün sonu yapıldı.');
    // Mevcut açık işlemi kapat
  }

  @override
  Future<void> addCashToRegister(double amount) async {
    await Future.delayed(const Duration(milliseconds: 100));
    print(
      '[InMemoryDayProcessRepository] Kasaya \$${amount.toStringAsFixed(2)} eklendi. Toplam: \$_cashInRegister',
    );
  }
}
