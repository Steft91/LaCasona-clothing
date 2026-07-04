import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_router.dart';
import '../design_system/atoms/casona_button.dart';
import '../design_system/molecules/casona_section_card.dart';

class LoginRequired extends StatelessWidget {
  const LoginRequired({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.lock_outline,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: CasonaSectionCard(
          icon: icon,
          title: title,
          subtitle: message,
          child: CasonaButton(
            text: 'Iniciar sesión',
            icon: Icons.login,
            onPressed: () => context.goNamed(AppRouter.login),
          ),
        ),
      ),
    );
  }
}
