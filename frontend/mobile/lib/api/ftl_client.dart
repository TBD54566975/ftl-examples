import 'dart:convert';
import 'package:http/http.dart' as http;

class FTLHttpClient {
  final String baseUrl;
  final http.Client httpClient;

  FTLHttpClient._({required this.baseUrl, required this.httpClient});

  static FTLHttpClient? _instance;

  static void initialize(
      {required String baseUrl, required http.Client httpClient}) {
    _instance = FTLHttpClient._(baseUrl: baseUrl, httpClient: httpClient);
  }

  static FTLHttpClient get instance {
    assert(_instance != null, 'FTLHttpClient must be initialized first');
    return _instance!;
  }

  Future<http.Response> get(
    String path, {
    Map<String, dynamic>? request,
    Map<String, String>? headers,
  }) {
    Uri uri;
    if (request == null || request.isEmpty) {
      uri = Uri.http("localhost:8892", '/ingress$path');
    } else {
      uri = Uri.http("localhost:8892", '/ingress$path', request);
    }
    return httpClient.get(uri, headers: headers);
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? request,
    Map<String, String>? headers,
  }) {
    return httpClient.post(
      Uri.http(baseUrl, '/ingress$path'),
      body: json.encode(request),
      headers: headers,
    );
  }
}
