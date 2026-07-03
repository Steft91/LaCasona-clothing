import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    this.message,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppTheme.woodGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.lineGold, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: AppTheme.heavyShadow,
                offset: Offset(0, 14),
                blurRadius: 24,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppTheme.parchmentGradient,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppTheme.burnishedGold),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.burnishedGold),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Icon(
                          icon,
                          size: 42,
                          color: AppTheme.deepWood,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.inkBrown,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        message!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.carvedWood,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
