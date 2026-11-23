import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/utils/validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/form_summary.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _startYear = TextEditingController();
  String _institution = '', _degree = 's1', _description = '';
  int? _endYear;
  static const _degrees = {
    'sma_smk': 'SMA/SMK',
    's1': 'S1',
    's2': 'S2',
    's3': 'S3',
  };

  @override
  void dispose() {
    _startYear.dispose();
    super.dispose();
  }

  // Model Django memakai IntegerField, sehingga inputnya tahun, bukan tanggal.
  String? _validateYear(String? value, {bool optional = false}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return optional ? null : 'Tahun mulai tidak boleh kosong!';
    }
    if (!RegExp(r'^[0-9]{4}$').hasMatch(text) || int.parse(text) < 1000) {
      return 'Masukkan tahun empat digit (1000-9999).';
    }
    if (optional) {
      final start = int.tryParse(_startYear.text.trim());
      if (start != null && int.parse(text) < start) {
        return 'Tahun selesai tidak boleh sebelum tahun mulai.';
      }
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    showFormSummary(
      context,
      title: 'Ringkasan Edukasi',
      values: {
        'Institusi': _institution,
        'Jenjang': _degrees[_degree]!,
        'Tahun mulai': _startYear.text.trim(),
        'Tahun selesai': _endYear?.toString() ?? 'Masih berlangsung',
        'Deskripsi': _description,
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Tambah Edukasi'),
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
                decoration: const InputDecoration(labelText: 'Nama Institusi'),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    requiredText(v, 'Nama institusi', maxLength: 255),
                onSaved: (v) => _institution = v!.trim(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Jenjang'),
                initialValue: 's1',
                isExpanded: true,
                items: _degrees.entries
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e.key, child: Text(e.value)),
                    )
                    .toList(),
                onChanged: (v) => _degree = v!,
                onSaved: (v) => _degree = v!,
                validator: (v) => _degrees.containsKey(v)
                    ? null
                    : 'Pilih jenjang pendidikan.',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startYear,
                decoration: const InputDecoration(
                  labelText: 'Tahun Mulai',
                  hintText: '2025',
                ),
                keyboardType: TextInputType.number,
                validator: (v) => _validateYear(v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tahun Selesai (opsional)',
                  helperText: 'Kosongkan jika masih berlangsung.',
                ),
                keyboardType: TextInputType.number,
                validator: (v) => _validateYear(v, optional: true),
                onSaved: (v) => _endYear = int.tryParse(v!.trim()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Deskripsi (opsional)',
                ),
                maxLines: 4,
                onSaved: (v) => _description = v!.trim(),
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
