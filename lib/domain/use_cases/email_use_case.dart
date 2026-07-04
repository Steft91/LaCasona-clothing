import '../entities/email_entity.dart';
import '../repositories/email_repository.dart';

class EmailUseCase {
  EmailUseCase(this._repository);

  final EmailRepository _repository;

  Future<void> call(EmailEntity email) => _repository.sendEmail(email);
}
