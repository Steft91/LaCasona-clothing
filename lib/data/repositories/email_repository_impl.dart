import '../../domain/entities/email_entity.dart';
import '../../domain/repositories/email_repository.dart';
import '../models/email_model.dart';
import '../services/send_service.dart';

class EmailRepositoryImpl implements EmailRepository {
  EmailRepositoryImpl({required this.sendService});

  final SendService sendService;

  @override
  Future<void> sendEmail(EmailEntity email) {
    return sendService.send(EmailModel.fromEntity(email));
  }
}
