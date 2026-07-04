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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(30),
            child: Ink(
              decoration: BoxDecoration(
                gradient: palette.gradient,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: palette.border),
                boxShadow: [
                  BoxShadow(
                    color: palette.shadow,
                    offset: const Offset(0, 12),
                    blurRadius: 26,
                  ),
                ],
              ),
              child: Padding(
                padding: compact
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
                    : const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                child: Center(child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ButtonPalette get _palette {
    return switch (variant) {
      CasonaButtonVariant.primary => const _ButtonPalette(
        gradient: AppTheme.goldGradient,
        text: AppTheme.espressoBlack,
        border: AppTheme.caramel,
        shadow: Color(0x553A1D0F),
      ),
      CasonaButtonVariant.terracotta => const _ButtonPalette(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.caramelLight, AppTheme.caramel],
        ),
        text: AppTheme.espressoBlack,
        border: AppTheme.caramelLight,
        shadow: Color(0x553A1D0F),
      ),
      CasonaButtonVariant.secondary => const _ButtonPalette(
        gradient: AppTheme.woodGradient,
        text: AppTheme.cream,
        border: AppTheme.hairline,
        shadow: AppTheme.warmShadow,
      ),
      CasonaButtonVariant.ghost => const _ButtonPalette(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.softBlack, AppTheme.softBlack],
        ),
        text: AppTheme.caramelLight,
        border: AppTheme.hairline,
        shadow: Colors.transparent,
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
      child: CircularProgressIndicator(strokeWidth: 2, color: color),
    );
  }
}
