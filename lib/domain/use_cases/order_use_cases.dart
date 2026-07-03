import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  CreateOrderUseCase(this._repository);

  final OrderRepository _repository;

  Future<String> call(OrderEntity order) => _repository.createOrder(order);
}

class GetOrdersUseCase {
  GetOrdersUseCase(this._repository);

  final OrderRepository _repository;

  Future<List<OrderEntity>> call(String userId) =>
      _repository.getOrders(userId);
}
