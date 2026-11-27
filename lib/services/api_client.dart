import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode);

  final int statusCode;

  @override
  String toString() => 'HTTP $statusCode';
}

class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  static const _timeout = Duration(seconds: 15);
  static const _projectsPath = '/api/v1/projects/';

  Uri _uri(String path) =>
      Uri.parse('${baseUrl.replaceFirst(RegExp(r'/+$'), '')}$path');

  Future<List<Project>> getProjects() async {
    final response = await _client
        .get(_uri(_projectsPath), headers: const {'Accept': 'application/json'})
        .timeout(_timeout);
    _ensureSuccess(response);
    final items = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return items
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _post(
      _projectsPath,
      body: project.toJson(),
      token: token,
    );
    return Project.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _post(
      '/api/v1/auth/token/',
      body: {'username': username, 'password': password},
    );
    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return data['token'] as String;
  }

  Future<void> logout({required String token}) async {
    await _post('/api/v1/auth/logout/', token: token);
  }

  Future<http.Response> _post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final response = await _client
        .post(
          _uri(path),
          headers: {
            'Accept': 'application/json',
            if (body != null) 'Content-Type': 'application/json; charset=UTF-8',
            if (token != null) 'Authorization': 'Token $token',
          },
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(_timeout);
    _ensureSuccess(response);
    return response;
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode);
    }
  }

  void close() => _client.close();
}
