import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

class ChatbotViewModel extends ChangeNotifier {
  ChatbotViewModel(this._productRepository);

  final ProductRepository _productRepository;

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
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw StateError('Falta GEMINI_API_KEY en .env');
      }

      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
      final inventory = await _productRepository.getAllProducts();
      final prompt = _buildPrompt(trimmed, inventory);
      final response = await model.generateContent([Content.text(prompt)]);
      messages.add(
        ChatMessageEntity(
          text: response.text ?? 'No pude responder en este momento.',
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
      return 'Falta configurar la clave de Casona AI.';
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

  String _buildPrompt(String userMessage, List<ProductEntity> products) {
    final availableProducts = products
        .where((product) => product.stock > 0)
        .take(40)
        .map(_productLine)
        .join('\n');

    return '''
Eres Casona AI, asistente de moda de La Casona.
Responde en español, con tono amable, moderno y breve.
No saludes de forma larga si el usuario solo dice hola.
No inventes productos, categorías, materiales, colecciones, descuentos ni stock.
Solo puedes recomendar prendas que aparezcan en el inventario disponible.
Si el usuario pide algo que no existe en el inventario, dilo claramente y ofrece 1 o 2 alternativas reales.
Si recomiendas outfits, arma combinaciones usando nombres exactos de productos reales.
Máximo 4 líneas salvo que el usuario pida más detalle.

Inventario disponible:
$availableProducts

Usuario: $userMessage
Respuesta:
''';
  }

  String _productLine(ProductEntity product) {
    return '- ${product.nombre} | categoria: ${product.categoria} | precio: \$${product.precio.toStringAsFixed(2)} | tallas: ${product.tallas.join(', ')} | colores: ${product.colores.join(', ')} | stock: ${product.stock} | descripcion: ${product.descripcion}';
  }
}
