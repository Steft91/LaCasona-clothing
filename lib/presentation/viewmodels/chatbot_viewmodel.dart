import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../domain/entities/chat_message_entity.dart';

class ChatbotViewModel extends ChangeNotifier {
  ChatbotViewModel();

  static const _systemPrompt =
      'Eres Casona AI, asistente de moda de La Casona, una tienda de ropa con estética colonial quiteña. Ayuda al usuario a encontrar prendas, recomienda outfits y responde preguntas sobre los productos.';

  final List<ChatMessageEntity> messages = [
    ChatMessageEntity(
      text: 'Hola, soy Casona AI. ¿Qué outfit quieres armar hoy?',
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
      final response = await model.generateContent([
        Content.text('$_systemPrompt\n\nUsuario: $trimmed'),
      ]);
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
}
