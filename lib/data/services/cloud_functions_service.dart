import 'package:cloud_functions/cloud_functions.dart';

import '../models/email_model.dart';

class CloudFunctionsService {
  CloudFunctionsService({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    final callable = _functions.httpsCallable('createPaymentIntent');
    final result = await callable.call<Map<String, dynamic>>({
      'amount': amount,
      'currency': currency,
    });

    return Map<String, dynamic>.from(result.data);
  }

  Future<void> sendPurchaseEmail(EmailModel email) async {
    final callable = _functions.httpsCallable('sendPurchaseEmail');
    await callable.call<void>({
      'destinatario': email.destinatario,
      'asunto': email.asunto,
      'contenido': email.contenido,
    });
  }

  Future<String> generateChatReply({
    required String userMessage,
    required List<String> inventory,
  }) async {
    final callable = _functions.httpsCallable('generateChatReply');
    final result = await callable.call<Map<String, dynamic>>({
      'message': userMessage,
      'inventory': inventory,
    });

    final data = Map<String, dynamic>.from(result.data);
    return data['reply'] as String? ?? 'No pude responder en este momento.';
  }
}
