import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/form_summary.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '',
      _description = '',
      _technologies = '',
      _link = '',
      _image = '';
  bool _submitting = false;

  Future<void> _save() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);

    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final token = auth.token;
      if (token == null) return;
      final project = await api.createProject(
        Project(
          title: _name,
          description: _description,
          techStack: _technologies,
          projectUrl: _link,
          projectImageUrl: _image,
        ),
        token: token,
      );
      if (!mounted) return;
      await showFormSummary(
        context,
        title: 'Proyek berhasil ditambahkan!',
        values: {
          'Nama Proyek': project.title,
          'Deskripsi': project.description,
          'Teknologi': project.techStack,
          'Tautan': project.projectUrl,
          if (project.projectImageUrl.isNotEmpty)
            'URL gambar': project.projectImageUrl,
        },
      );
      if (mounted) _formKey.currentState!.reset();
    } on ApiException catch (error) {
      if (error.statusCode == 401) {
        if (mounted) await logoutWithFeedback(context);
        if (!mounted) return;
        _showError('Sesi berakhir. Login ulang, lalu tekan Simpan.');
        await ensureLoggedIn(context);
      } else if (error.statusCode == 403) {
        _showError('Akun ini tidak memiliki izin untuk menambahkan proyek.');
      } else {
        _showError('Proyek gagal disimpan (HTTP ${error.statusCode}).');
      }
    } catch (_) {
      _showError('Proyek gagal disimpan. Periksa koneksi dan coba lagi.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Tambah Proyek'),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    drawer: const LeftDrawer(),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama Proyek'),
                validator: (v) =>
                    requiredText(v, 'Nama proyek', maxLength: 255),
                onSaved: (v) => _name = v!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Proyek',
                ),
                maxLines: 5,
                validator: (v) => requiredText(v, 'Deskripsi proyek'),
                onSaved: (v) => _description = v!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Teknologi yang Digunakan',
                  hintText: 'Flutter, Django, Figma',
                ),
                validator: (v) => requiredText(v, 'Teknologi', maxLength: 255),
                onSaved: (v) => _technologies = v!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tautan Proyek (opsional)',
                ),
                keyboardType: TextInputType.url,
                validator: optionalUrl,
                onSaved: (v) => _link = v!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'URL Gambar Proyek (opsional)',
                ),
                keyboardType: TextInputType.url,
                validator: optionalUrl,
                onSaved: (value) => _image = value!.trim(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitting ? null : _save,
                child: Text(_submitting ? 'Sedang menyimpan?' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
