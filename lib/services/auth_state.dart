import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._apiClient);

  final ApiClient _apiClient;
  String? _token;
  Future<void>? _revocation;

  String? get token => _token;
  bool get isLoggedIn => _token != null;

  Future<void> login(String username, String password) async {
    try {
      await _revocation;
    } catch (_) {
      // A failed revocation does not prevent a new login.
    }
    _token = await _apiClient.obtainToken(username, password);
    notifyListeners();
  }

  Future<void> logout() async {
    final token = _token;
    if (token == null) return;

    final revocation = _apiClient.logout(token: token);
    _revocation = revocation;
    _token = null;
    notifyListeners();
    try {
      await revocation;
    } on ApiException catch (error) {
      if (error.statusCode != 401) rethrow;
    } finally {
      _revocation = null;
    }
  }
}
