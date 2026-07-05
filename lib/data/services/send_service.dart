import '../models/email_model.dart';
import 'cloud_functions_service.dart';

class SendService {
  SendService({CloudFunctionsService? functionsService})
    : _functionsService = functionsService ?? CloudFunctionsService();

  final CloudFunctionsService _functionsService;

  Future<void> send(EmailModel email) async {
    try {
      await _functionsService.sendPurchaseEmail(email);
    } catch (exception) {
      throw Exception('Error al enviar el correo: $exception');
    }
  }
}
