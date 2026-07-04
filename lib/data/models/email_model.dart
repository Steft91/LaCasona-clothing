import '../../domain/entities/email_entity.dart';

/// SendGrid-compatible model for [EmailEntity].
class EmailModel extends EmailEntity {
  const EmailModel({
    required super.destinatario,
    required super.asunto,
    required super.contenido,
  });

  factory EmailModel.fromEntity(EmailEntity entity) {
    return EmailModel(
      destinatario: entity.destinatario,
      asunto: entity.asunto,
      contenido: entity.contenido,
    );
  }

  Map<String, dynamic> toSendGridJson({
    required String fromEmail,
    required String fromName,
  }) {
    return {
      'personalizations': [
        {
          'to': [
            {'email': destinatario},
          ],
          'subject': asunto,
        },
      ],
      'from': {'email': fromEmail, 'name': fromName},
      'content': [
        {'type': 'text/html', 'value': contenido},
      ],
    };
  }
}
