import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  Color _statusColor(String status) {
    return switch (status.toLowerCase()) {
      'confirmado' => AppTheme.antiqueGold,
      'enviado' => AppTheme.gardenGreen,
      'entregado' => AppTheme.successColor,
      'cancelado' => AppTheme.errorColor,
      _ => AppTheme.terracotta,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.95),
            AppTheme.walnut,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.softGold, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.warmShadow,
            offset: Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          status,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.lightText,
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}
