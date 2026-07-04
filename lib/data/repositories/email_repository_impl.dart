import '../../domain/entities/email_entity.dart';
import '../../domain/repositories/email_repository.dart';
import '../models/email_model.dart';
import '../services/send_service.dart';

class EmailRepositoryImpl implements EmailRepository {
  EmailRepositoryImpl({required SendService sendService})
    : _sendService = sendService;

  final SendService _sendService;

  @override
  Future<void> sendEmail(EmailEntity email) {
    return _sendService.send(EmailModel.fromEntity(email));
  }
}
