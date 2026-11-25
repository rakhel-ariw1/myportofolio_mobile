import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;
  return await Navigator.of(context).push<bool>(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  ) ?? false;
}

Future<void> logoutWithFeedback(BuildContext context) async {
  final auth = context.read<AuthState>();
  if (!auth.isLoggedIn) return;
  final String message;
  try {
    await auth.logout();
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keluar dari aplikasi. Token gagal dicabut di server.')),
      );
    }
    return;
  }
  message = 'Berhasil logout.';
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
