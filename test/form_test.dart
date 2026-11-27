import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
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

Future<void> login(WidgetTester tester) async {
  await tester.enterText(field('Username'), 'admin');
  await tester.enterText(field('Password'), 'test-password');
  await tester.tap(find.widgetWithText(FilledButton, 'Login'));
  await tester.pumpAndSettle();
}

ApiClient authenticatedApi() => ApiClient(
  client: MockClient((request) async {
    expect(request.method, 'POST');
    switch (request.url.path) {
      case '/api/v1/auth/token/':
        expect(jsonDecode(request.body), {
          'username': 'admin',
          'password': 'test-password',
        });
        return http.Response('{"token":"test-token"}', 200);
      case '/api/v1/auth/logout/':
        expect(request.headers['authorization'], 'Token test-token');
        return http.Response('', 204);
      case '/api/v1/projects/':
        expect(request.headers['authorization'], 'Token test-token');
        final data = jsonDecode(request.body) as Map<String, dynamic>;
        expect(data, {
          'title': 'Portofolio',
          'description': 'Aplikasi mobile',
          'tech_stack': 'Flutter',
          'project_url': 'https://example.com',
          'project_image_url': '',
        });
        return http.Response(jsonEncode({...data, 'id': 'abc'}), 201);
      default:
        fail('Unexpected request to ${request.url}');
    }
  }),
);

void main() {
  for (final name in ['Tambah Proyek', 'Tambah Edukasi']) {
    testWidgets('Kartu $name membuka form dan Back kembali ke Home', (
      tester,
    ) async {
      final api = authenticatedApi();
      addTearDown(api.close);
      await tester.pumpWidget(MyApp(apiClient: api));
      await tester.ensureVisible(find.text(name));
      await tester.tap(find.text(name));
      await tester.pumpAndSettle();
      if (name == 'Tambah Proyek') {
        expect(find.byType(ProjectFormPage), findsNothing);
        await login(tester);
        expect(find.byType(ProjectFormPage), findsOneWidget);
      } else {
        expect(find.byType(EducationFormPage), findsOneWidget);
      }
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('2506605462'), findsOneWidget);
    });
  }

  testWidgets('Drawer menghubungkan Home, proyek, dan edukasi', (tester) async {
    final api = authenticatedApi();
    addTearDown(api.close);
    await tester.pumpWidget(MyApp(apiClient: api));
    for (final destination in ['Add Project', 'Add Education', 'Home']) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(destination));
      await tester.pumpAndSettle();
      if (destination == 'Add Project') {
        await login(tester);
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
    final api = authenticatedApi();
    addTearDown(api.close);
    await tester.pumpWidget(MyApp(apiClient: api));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();
    await login(tester);
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
      'Teknologi: Flutter',
      'Tautan: https://example.com',
    ]) {
      expect(find.text(text), findsOneWidget);
    }
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await save(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Berhasil logout.'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
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
