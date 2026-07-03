import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

enum CasonaButtonVariant { primary, secondary, ghost, terracotta }

class CasonaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final CasonaButtonVariant variant;
  final bool fullWidth;
  final bool compact;

  const CasonaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = CasonaButtonVariant.primary,
    this.fullWidth = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final palette = _palette;

    final content = icon == null
        ? _ButtonLabel(text: text, isLoading: isLoading, color: palette.text)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? _LoadingIndicator(color: palette.text)
                  : Icon(icon, size: 19, color: palette.text),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: palette.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: compact ? 42 : 58,
      child: Opacity(
        opacity: enabled ? 1 : 0.56,
        child: Stack(
          children: [
            Positioned.fill(
              top: compact ? 5 : 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.shadow,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: enabled ? onPressed : null,
                borderRadius: BorderRadius.circular(9),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: palette.gradient,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: palette.border, width: 1.4),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.warmShadow,
                        offset: Offset(0, compact ? 4 : 7),
                        blurRadius: compact ? 9 : 13,
                      ),
                    ],
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.22),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: compact
                          ? const EdgeInsets.fromLTRB(14, 9, 14, 12)
                          : const EdgeInsets.fromLTRB(20, 15, 20, 19),
                      child: Center(child: content),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _ButtonPalette get _palette {
    return switch (variant) {
      CasonaButtonVariant.primary => const _ButtonPalette(
          gradient: AppTheme.woodGradient,
          text: AppTheme.lightText,
          border: AppTheme.lineGold,
          shadow: AppTheme.deepWood,
        ),
      CasonaButtonVariant.terracotta => const _ButtonPalette(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.mutedTerracotta,
              AppTheme.terracotta,
              AppTheme.mahogany,
            ],
          ),
          text: AppTheme.lightText,
          border: AppTheme.softGold,
          shadow: AppTheme.deepWood,
        ),
      CasonaButtonVariant.secondary => const _ButtonPalette(
          gradient: AppTheme.goldGradient,
          text: AppTheme.deepWood,
          border: AppTheme.softGold,
          shadow: AppTheme.burnishedGold,
        ),
      CasonaButtonVariant.ghost => const _ButtonPalette(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.walnut,
              AppTheme.smokedCedar,
              AppTheme.deepWood,
            ],
          ),
          text: AppTheme.softGold,
          border: AppTheme.lineGold,
          shadow: AppTheme.deepWood,
        ),
    };
  }
}

class _ButtonPalette {
  const _ButtonPalette({
    required this.gradient,
    required this.text,
    required this.border,
    required this.shadow,
  });

  final Gradient gradient;
  final Color text;
  final Color border;
  final Color shadow;
}

class _ButtonLabel extends StatelessWidget {
  const _ButtonLabel({
    required this.text,
    required this.isLoading,
    required this.color,
  });

  final String text;
  final bool isLoading;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _LoadingIndicator(color: color);
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
          ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color,
      ),
    );
  }
}
