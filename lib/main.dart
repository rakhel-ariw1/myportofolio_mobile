import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.apiClient});

  final ApiClient? apiClient;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        if (apiClient case final client?)
          Provider<ApiClient>.value(value: client)
        else
          Provider(create: (_) => ApiClient(), dispose: (_, api) => api.close()),
        ChangeNotifierProvider(create: (context) => AuthState(context.read())),
      ],
      child: MaterialApp(
      title: 'MyPortfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          secondary: Colors.amber[700],
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const MyHomePage(),
      ),
    );
  }
}
