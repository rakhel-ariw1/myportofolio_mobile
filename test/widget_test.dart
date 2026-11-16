import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  testWidgets('Identitas dan tiga menu dengan warna berbeda tampil', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('2506605462'), findsOneWidget);
    expect(find.text('Rakhel Aqeela Hapsari Ariwibowo'), findsOneWidget);
    expect(find.text('PBP B'), findsOneWidget);
    expect(find.byType(InfoCard), findsNWidgets(3));
    expect(find.byType(ItemCard), findsNWidgets(3));
    final colors = tester
        .widgetList<Material>(
          find.descendant(
            of: find.byType(ItemCard),
            matching: find.byType(Material),
          ),
        )
        .map((widget) => widget.color)
        .toSet();
    expect(colors.length, 3);
    expect(tester.takeException(), isNull);
  });

  for (final name in ['Lihat Proyek', 'Tambah Proyek', 'Logout']) {
    testWidgets('Tombol $name menampilkan SnackBar yang sesuai', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.text(name));
      await tester.pumpAndSettle();
      expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
    });
  }

  testWidgets('Layar kecil dapat digulir tanpa overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
