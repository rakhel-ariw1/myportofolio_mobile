import 'package:flutter/material.dart';
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
  String _name = '', _description = '', _technologies = '', _link = '';
  String _category = 'Web Development';
  static const _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    await showFormSummary(
      context,
      title: 'Proyek berhasil ditambahkan!',
      values: {
        'Nama Proyek': _name,
        'Deskripsi': _description,
        'Kategori': _category,
        'Teknologi': _technologies,
        'Tautan': _link,
      },
    );
    if (!mounted) return;
    _formKey.currentState!.reset();
    _name = _description = _technologies = _link = '';
    _category = _categories.first;
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Kategori Proyek'),
                initialValue: _categories.first,
                isExpanded: true,
                items: _categories
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => _category = v!,
                onSaved: (v) => _category = v!,
                validator: (v) =>
                    _categories.contains(v) ? null : 'Pilih kategori proyek.',
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
              const SizedBox(height: 24),
              FilledButton(onPressed: _save, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    ),
  );
}
