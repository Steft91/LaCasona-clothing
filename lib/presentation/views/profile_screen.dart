import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/auth_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppTheme.accentBeige.withValues(alpha: 0.2),
            child: const Icon(Icons.person, size: 42, color: AppTheme.darkText),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              user?.nombre ?? 'Cliente',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 6),
          Center(child: Text(user?.email ?? '')),
          const SizedBox(height: 24),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            leading: const Icon(Icons.straighten),
            title: const Text('Talla'),
            subtitle: Text(
              user?.talla.isNotEmpty == true ? user!.talla : 'No configurada',
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Historial de pedidos'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(AppRouter.orders),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            secondary: const Icon(Icons.fingerprint),
            title: const Text('Acceso biométrico'),
            subtitle: Text(auth.biometricSummary),
            value: auth.isBiometricEnabled,
            onChanged: auth.isLoading
                ? null
                : (enabled) {
                    if (enabled) {
                      _showEnableBiometricDialog(context);
                    } else {
                      context.read<AuthViewModel>().disableBiometricLogin();
                    }
                  },
          ),
          if (auth.error != null) ...[
            const SizedBox(height: 12),
            Text(
              auth.error!,
              style: const TextStyle(color: AppTheme.errorColor),
            ),
          ],
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () async {
              await context.read<AuthViewModel>().logout();
              if (context.mounted) context.goNamed(AppRouter.login);
            },
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEnableBiometricDialog(BuildContext context) async {
    final auth = context.read<AuthViewModel>();
    if (auth.availableBiometricMethods.isEmpty) {
      await auth.loadCurrentUser();
    }

    if (!context.mounted) return;
    if (auth.availableBiometricMethods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay huella o rostro configurado en este teléfono.'),
        ),
      );
      return;
    }

    var typedPassword = '';
    final selectedMethods = <String>{auth.availableBiometricMethods.first};
    final result = await showDialog<_BiometricSetupResult>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Activar biometría'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  typedPassword = value;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirma tu contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Elige cómo quieres entrar',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 8),
              ...auth.availableBiometricMethods.map(
                (method) => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: selectedMethods.contains(method),
                  onChanged: (selected) {
                    setDialogState(() {
                      if (selected == true) {
                        selectedMethods.add(method);
                      } else {
                        selectedMethods.remove(method);
                      }
                    });
                  },
                  secondary: Icon(
                    method == 'face' ? Icons.face : Icons.fingerprint,
                  ),
                  title: Text(
                    method == 'face'
                        ? 'Reconocimiento facial'
                        : 'Huella digital',
                  ),
                ),
              ),
              Text(
                'El teléfono mostrará el método permitido por el sistema al validar.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.darkText.withValues(alpha: 0.62),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: selectedMethods.isEmpty
                  ? null
                  : () => Navigator.pop(
                      dialogContext,
                      _BiometricSetupResult(
                        password: typedPassword,
                        methods: selectedMethods.toList(),
                      ),
                    ),
              child: const Text('Activar'),
            ),
          ],
        ),
      ),
    );

    if (result == null || !context.mounted) return;
    final success = await context.read<AuthViewModel>().enableBiometricLogin(
      result.password,
      result.methods,
    );
    if (!context.mounted || !success) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Acceso biométrico activado')));
  }
}

class _BiometricSetupResult {
  const _BiometricSetupResult({required this.password, required this.methods});

  final String password;
  final List<String> methods;
}
