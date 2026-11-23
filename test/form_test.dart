import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

Finder field(String label) => find.byWidgetPredicate(
  (widget) => widget is TextField && widget.decoration?.labelText == label,
);

Future<void> save(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Simpan'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Simpan'));
  await tester.pumpAndSettle();
}

void main() {
  for (final name in ['Tambah Proyek', 'Tambah Edukasi']) {
    testWidgets('Kartu $name membuka form dan Back kembali ke Home', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.ensureVisible(find.text(name));
      await tester.tap(find.text(name));
      await tester.pumpAndSettle();
      expect(find.byType(Form), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('2506605462'), findsOneWidget);
    });
  }

  testWidgets('Drawer menghubungkan Home, proyek, dan edukasi', (tester) async {
    await tester.pumpWidget(const MyApp());
    for (final destination in ['Add Project', 'Add Education', 'Home']) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(destination));
      await tester.pumpAndSettle();
      if (destination == 'Add Project') {
        expect(find.byType(ProjectFormPage), findsOneWidget);
      } else if (destination == 'Add Education') {
        expect(find.byType(EducationFormPage), findsOneWidget);
      } else {
        expect(find.text('2506605462'), findsOneWidget);
      }
    }
  });

  testWidgets('Edukasi menolak kosong, panjang, format, dan urutan tahun', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
    await tester.enterText(field('Nama Institusi'), '   ');
    await save(tester);
    expect(find.text('Nama institusi tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Tahun mulai tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    await tester.enterText(field('Nama Institusi'), 'a' * 256);
    await tester.enterText(field('Tahun Mulai'), 'abc');
    await save(tester);
    expect(find.text('Nama institusi maksimal 255 karakter.'), findsOneWidget);
    expect(
      find.text('Masukkan tahun empat digit (1000-9999).'),
      findsOneWidget,
    );
    await tester.enterText(field('Nama Institusi'), 'Universitas Indonesia');
    await tester.enterText(field('Tahun Mulai'), '2025');
    await tester.enterText(field('Tahun Selesai (opsional)'), '2024');
    await save(tester);
    expect(
      find.text('Tahun selesai tidak boleh sebelum tahun mulai.'),
      findsOneWidget,
    );
    await tester.enterText(field('Tahun Selesai (opsional)'), '2029');
    await tester.enterText(field('Deskripsi (opsional)'), 'Ilmu Komputer');
    await save(tester);
    for (final text in [
      'Institusi: Universitas Indonesia',
      'Jenjang: S1',
      'Tahun mulai: 2025',
      'Tahun selesai: 2029',
      'Deskripsi: Ilmu Komputer',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    await tester.enterText(field('Tahun Selesai (opsional)'), '');
    await save(tester);
    expect(find.text('Tahun selesai: Masih berlangsung'), findsOneWidget);
  });

  testWidgets('Proyek memvalidasi URL, menampilkan semua input, lalu reset', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await save(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    await tester.enterText(field('Nama Proyek'), 'Portofolio');
    await tester.enterText(field('Deskripsi Proyek'), 'Aplikasi mobile');
    await tester.enterText(field('Teknologi yang Digunakan'), 'Flutter');
    await tester.enterText(field('Tautan Proyek (opsional)'), 'bukan-url');
    await save(tester);
    expect(find.byType(AlertDialog), findsNothing);
    await tester.enterText(
      field('Tautan Proyek (opsional)'),
      'https://example.com',
    );
    await save(tester);
    for (final text in [
      'Nama Proyek: Portofolio',
      'Deskripsi: Aplikasi mobile',
      'Kategori: Web Development',
      'Teknologi: Flutter',
      'Tautan: https://example.com',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await save(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
  });

  testWidgets('Form layar kecil dengan keyboard tetap dapat disimpan', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 220);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: EducationFormPage()));
    await tester.enterText(field('Nama Institusi'), 'UI');
    await tester.enterText(field('Tahun Mulai'), '2025');
    await save(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
