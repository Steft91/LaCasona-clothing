import 'package:intl/intl.dart';

/// General-purpose utility helpers for La Casona.
class AppUtils {
  AppUtils._();

  /// Format a [double] as currency (USD).
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Format a [DateTime] as a human-readable date string.
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Format a [DateTime] as a human-readable date+time string.
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy – hh:mm a').format(date);
  }

  /// Truncate a string to [maxLength] characters with ellipsis.
  static String truncate(String text, {int maxLength = 80}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}…';
  }
}
