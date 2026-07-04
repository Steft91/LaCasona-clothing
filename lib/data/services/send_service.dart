import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/email_model.dart';

class SendService {
  SendService({
    required String apiKey,
    required String fromEmail,
    String fromName = 'La Casona',
    http.Client? client,
  }) : _apiKey = apiKey,
       _fromEmail = fromEmail,
       _fromName = fromName,
       _client = client ?? http.Client();

  static final Uri _sendGridUri = Uri.parse(
    'https://api.sendgrid.com/v3/mail/send',
  );

  final String _apiKey;
  final String _fromEmail;
  final String _fromName;
  final http.Client _client;

  Future<void> send(EmailModel email) async {
    if (_apiKey.trim().isEmpty || _fromEmail.trim().isEmpty) {
      throw Exception('Configura SENDGRID_API_KEY y SENDGRID_FROM_EMAIL.');
    }

    try {
      final response = await _client.post(
        _sendGridUri,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          email.toSendGridJson(fromEmail: _fromEmail, fromName: _fromName),
        ),
      );

      if (response.statusCode != 202) {
        throw Exception(
          'SendGrid respondio con codigo ${response.statusCode}.',
        );
      }
    } on http.ClientException catch (exception) {
      throw Exception('Error de red al enviar el correo: ${exception.message}');
    }
  }
}
