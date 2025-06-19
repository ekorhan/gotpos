// src/domain/repositories/table_repository.dart

abstract class PaymentRepository {
  Future<String> createOrder(String branchId, price);
  Future<bool> processPayment(
    String deviceId,
    String orderId,
    String paymentMethod,
    double amount,
  );
}
