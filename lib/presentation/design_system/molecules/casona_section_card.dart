import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class CasonaSectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CasonaSectionCard({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppTheme.woodGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.warmShadow,
            offset: Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 7),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppTheme.parchmentGradient,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppTheme.lineGold, width: 1.3),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Row(
                  children: const [
                    _CarvedColumn(),
                    Spacer(),
                    _CarvedColumn(),
                  ],
                ),
              ),
              Padding(
                padding: padding.add(const EdgeInsets.symmetric(horizontal: 10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (icon != null) ...[
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: AppTheme.goldGradient,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.burnishedGold,
                                  width: 1.2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppTheme.warmShadow,
                                    offset: Offset(0, 3),
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(9),
                                child: Icon(
                                  icon,
                                  color: AppTheme.deepWood,
                                  size: 19,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: AppTheme.inkBrown),
                                ),
                                if (subtitle != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    subtitle!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppTheme.carvedWood,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    IconTheme(
                      data: const IconThemeData(color: AppTheme.mahogany),
                      child: DefaultTextStyle.merge(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.inkBrown,
                              fontWeight: FontWeight.w700,
                            ),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarvedColumn extends StatelessWidget {
  const _CarvedColumn();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppTheme.deepWood,
            AppTheme.mahogany,
            AppTheme.softGold,
            AppTheme.carvedWood,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
