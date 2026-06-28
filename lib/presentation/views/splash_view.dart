import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_router.dart';

/// Pantalla temporal de bienvenida para verificar que el proyecto
/// compila correctamente y el tema colonial se aplica.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.goNamed(AppRouter.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono decorativo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.accentBeige.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.accentBeige, width: 2),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 48,
                color: AppTheme.accentBeige,
              ),
            ),
            const SizedBox(height: 32),

            // Título
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),

            // Subtítulo
            Text(
              AppConstants.appTagline,
              style: GoogleFonts.lato(
                fontSize: 16,
                color: AppTheme.darkText.withValues(alpha: 0.6),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 48),

            // Botón de prueba
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ ¡Todo funciona correctamente!'),
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Probar tema'),
            ),
            const SizedBox(height: 16),

            // Info del proyecto
            Text(
              'Firebase · Provider · go_router',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.darkText.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
