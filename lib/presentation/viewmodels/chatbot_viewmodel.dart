import 'package:flutter/foundation.dart';

import '../../data/services/cloud_functions_service.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

class ChatbotViewModel extends ChangeNotifier {
  ChatbotViewModel(
    this._productRepository, {
    CloudFunctionsService? functionsService,
  }) : _functionsService = functionsService ?? CloudFunctionsService();

  final ProductRepository _productRepository;
  final CloudFunctionsService _functionsService;

  final List<ChatMessageEntity> messages = [
    ChatMessageEntity(
      text: 'Hola, soy Casona AI. ¿Buscas alguna prenda u outfit?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  bool isLoading = false;
  String? error;

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    messages.add(
      ChatMessageEntity(text: trimmed, isUser: true, timestamp: DateTime.now()),
    );
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final inventory = await _productRepository.getAllProducts();
      final reply = await _functionsService.generateChatReply(
        userMessage: trimmed,
        inventory: _inventoryLines(inventory),
      );
      messages.add(
        ChatMessageEntity(
          text: reply,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } catch (exception) {
      error = _friendlyError(exception);
      messages.add(
        ChatMessageEntity(
          text: error!,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _friendlyError(Object exception) {
    final message = exception.toString();
    if (message.contains('GEMINI_API_KEY')) {
      return 'Falta configurar la clave de Casona AI en Firebase Functions.';
    }
    if (message.contains('API_KEY_INVALID') ||
        message.contains('PERMISSION_DENIED')) {
      return 'La clave de Casona AI no es válida o no tiene permisos.';
    }
    if (message.contains('not found') || message.contains('NOT_FOUND')) {
      return 'El modelo de Casona AI no está disponible. Revisa la configuración.';
    }
    if (message.contains('SocketException') ||
        message.contains('ClientException')) {
      return 'No hay conexión con Casona AI. Revisa tu internet.';
    }
    return 'No pude conectar con Casona AI. Intenta de nuevo.';
  }

  List<String> _inventoryLines(List<ProductEntity> products) {
    return products
        .where((product) => product.stock > 0)
        .take(40)
        .map(_productLine)
        .toList(growable: false);
  }

  String _productLine(ProductEntity product) {
    return '- ${product.nombre} | categoria: ${product.categoria} | precio: \$${product.precio.toStringAsFixed(2)} | tallas: ${product.tallas.join(', ')} | colores: ${product.colores.join(', ')} | stock: ${product.stock} | descripcion: ${product.descripcion}';
  }
}
