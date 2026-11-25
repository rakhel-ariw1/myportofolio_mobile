import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _submitting = false;

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    try {
      await context.read<AuthState>().login(_username, _password);
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (error) {
      _showError('Login gagal (HTTP ${error.statusCode}).');
    } catch (_) {
      _showError('Login gagal. Periksa koneksi dan coba lagi.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_submitting,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) => requiredText(value, 'Username'),
              onSaved: (value) => _username = value!.trim(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) => value == null || value.isEmpty
                  ? 'Password tidak boleh kosong!'
                  : null,
              onSaved: (value) => _password = value!,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: Text(_submitting ? 'Sedang login…' : 'Login'),
            ),
          ],
        ),
      ),
    ),
  );
}
