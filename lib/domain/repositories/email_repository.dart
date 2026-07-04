import '../entities/email_entity.dart';

/// Contract for email delivery operations.
abstract class EmailRepository {
  Future<void> sendEmail(EmailEntity email);
}
