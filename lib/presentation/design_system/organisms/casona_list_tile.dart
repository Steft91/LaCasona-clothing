import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class CasonaListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const CasonaListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppTheme.woodGradient,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.lineGold),
            boxShadow: const [
              BoxShadow(
                color: AppTheme.warmShadow,
                offset: Offset(0, 7),
                blurRadius: 13,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 6),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppTheme.parchmentGradient,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.burnishedGold),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (leading != null) ...[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: AppTheme.goldGradient,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: AppTheme.burnishedGold),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: IconTheme(
                            data: const IconThemeData(
                              color: AppTheme.deepWood,
                              size: 20,
                            ),
                            child: leading!,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.inkBrown,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 3),
                            Text(
                              subtitle!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.carvedWood,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 8),
                      IconTheme(
                        data: const IconThemeData(
                          color: AppTheme.mahogany,
                          size: 20,
                        ),
                        child: trailing!,
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
