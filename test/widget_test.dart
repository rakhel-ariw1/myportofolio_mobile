import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

void main() {
  testWidgets('Identitas dan empat menu dengan warna berbeda tampil', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('2506605462'), findsOneWidget);
    expect(find.text('Rakhel Aqeela Hapsari Ariwibowo'), findsOneWidget);
    expect(find.text('PBP B'), findsOneWidget);
    expect(find.byType(InfoCard), findsNWidgets(3));
    expect(find.byType(ItemCard), findsNWidgets(4));
    final colors = tester
        .widgetList<Material>(
          find.descendant(
            of: find.byType(ItemCard),
            matching: find.byType(Material),
          ),
        )
        .map((widget) => widget.color)
        .toSet();
    expect(colors.length, 4);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Daftar dan detail proyek dapat dibuka tanpa login', (
    tester,
  ) async {
    final api = ApiClient(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/v1/projects/');
        expect(request.headers['authorization'], isNull);
        return http.Response(
          '[{"id":"abc","title":"Portofolio","description":"Aplikasi mobile",'
          '"tech_stack":"Flutter","project_url":"https://example.com"}]',
          200,
        );
      }),
    );
    addTearDown(api.close);
    await tester.pumpWidget(MyApp(apiClient: api));
    await tester.tap(find.text('Lihat Proyek'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Portofolio'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Proyek'), findsOneWidget);
    expect(find.text('https://example.com'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('Layar kecil dapat digulir tanpa overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Login'));
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.text('Username'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
