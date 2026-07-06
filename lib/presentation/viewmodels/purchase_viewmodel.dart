import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/email_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/use_cases/email_use_case.dart';

class PurchaseViewModel extends ChangeNotifier {
  PurchaseViewModel(this._emailUseCase);

  final EmailUseCase _emailUseCase;

  bool isSendingEmail = false;
  String? emailError;

  Future<bool> sendPurchaseConfirmation({
    required String userName,
    required String recipientEmail,
    required OrderEntity order,
  }) async {
    isSendingEmail = true;
    emailError = null;
    notifyListeners();

    try {
      final email = EmailEntity(
        destinatario: recipientEmail,
        asunto: 'Resumen de compra - ${AppConstants.appName}',
        contenido: _buildPurchaseSummaryHtml(userName: userName, order: order),
      );
      await _emailUseCase(email);
      isSendingEmail = false;
      notifyListeners();
      return true;
    } catch (exception) {
      emailError =
          'Compra realizada. No se pudo enviar el comprobante por correo.';
      isSendingEmail = false;
      notifyListeners();
      return false;
    }
  }

  String _buildPurchaseSummaryHtml({
    required String userName,
    required OrderEntity order,
  }) {
    final currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final date = DateFormat('dd/MM/yyyy HH:mm').format(order.fechaCreacion);
    final itemsRows = order.items.map((item) {
      final subtotal = item.precio * item.cantidad;
      return '''
        <tr>
          <td style="padding: 10px 8px; border-bottom: 1px solid #eadfce;">
            <strong>${_escape(item.nombre)}</strong><br>
            <span style="color: #6b5a4a;">Talla: ${_escape(item.talla)} | Color: ${_escape(item.color)}</span>
          </td>
          <td style="padding: 10px 8px; border-bottom: 1px solid #eadfce; text-align: center;">${item.cantidad}</td>
          <td style="padding: 10px 8px; border-bottom: 1px solid #eadfce; text-align: right;">${currency.format(subtotal)}</td>
        </tr>
      ''';
    }).join();

    return '''
      <div style="font-family: Arial, sans-serif; color: #34251c; max-width: 640px; margin: 0 auto; line-height: 1.5;">
        <div style="background: #4b2f24; color: #fff8ef; padding: 24px; text-align: center;">
          <h1 style="margin: 0; font-size: 28px;">${AppConstants.appName}</h1>
          <p style="margin: 6px 0 0;">${AppConstants.appTagline}</p>
        </div>
        <div style="padding: 24px; border: 1px solid #eadfce; border-top: 0;">
          <h2 style="margin-top: 0;">Gracias por tu compra, ${_escape(userName)}</h2>
          <p>Tu pedido fue registrado correctamente. Este es el resumen de tu compra:</p>
          <p>
            <strong>Orden:</strong> ${_escape(order.id)}<br>
            <strong>Fecha:</strong> $date<br>
            <strong>Direccion de entrega:</strong> ${_escape(order.direccionEntrega)}
          </p>
          <table style="width: 100%; border-collapse: collapse; margin-top: 18px;">
            <thead>
              <tr style="background: #f6efe5;">
                <th style="padding: 10px 8px; text-align: left;">Producto</th>
                <th style="padding: 10px 8px; text-align: center;">Cant.</th>
                <th style="padding: 10px 8px; text-align: right;">Subtotal</th>
              </tr>
            </thead>
            <tbody>$itemsRows</tbody>
          </table>
          <p style="font-size: 20px; text-align: right; margin-top: 22px;">
            <strong>Total: ${currency.format(order.total)}</strong>
          </p>
          <p style="color: #6b5a4a;">Con cariño,<br>Equipo ${AppConstants.appName}</p>
        </div>
      </div>
    ''';
  }

  String _escape(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }
}
