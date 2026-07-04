/// Domain entity representing an email to be sent.
class EmailEntity {
  final String destinatario;
  final String asunto;
  final String contenido;

  const EmailEntity({
    required this.destinatario,
    required this.asunto,
    required this.contenido,
  });
}
