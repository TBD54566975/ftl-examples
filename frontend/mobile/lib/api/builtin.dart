// ignore_for_file: unused_import
library builtin;

import 'dart:convert';
import 'dart:typed_data';
import 'ftl_client.dart';


class HttpRequest {
  String method;
  String path;
  Map<String, List<String>> query;
  Map<String, List<String>> headers;
  Uint8List body;

  HttpRequest({  required this.method,  required this.path,  required this.query,  required this.headers,  required this.body,  });

  Map<String, dynamic> toMap() {
    return {
      'method': ((dynamic v) => v)(method),
      'path': ((dynamic v) => v)(path),
      'query': ((dynamic v) => v.map((k, v) => MapEntry(k, v.map((v) => v).cast<String>().toList())).cast<String, List<String>>())(query),
      'headers': ((dynamic v) => v.map((k, v) => MapEntry(k, v.map((v) => v).cast<String>().toList())).cast<String, List<String>>())(headers),
      'body': ((dynamic v) => v)(body),
    };
  }

  factory HttpRequest.fromMap(Map<String, dynamic> map) {
    return HttpRequest(
      method: ((dynamic v) => v)(map['method']),
      path: ((dynamic v) => v)(map['path']),
      query: ((dynamic v) => v.map((k, v) => MapEntry(k, v.map((v) => v).cast<String>().toList())).cast<String, List<String>>())(map['query']),
      headers: ((dynamic v) => v.map((k, v) => MapEntry(k, v.map((v) => v).cast<String>().toList())).cast<String, List<String>>())(map['headers']),
      body: ((dynamic v) => v)(map['body']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HttpRequest.fromJson(String source) => HttpRequest.fromMap(json.decode(source));
}

class HttpResponse {
  int status;
  Map<String, List<String>> headers;
  Uint8List body;

  HttpResponse({  required this.status,  required this.headers,  required this.body,  });

  Map<String, dynamic> toMap() {
    return {
      'status': ((dynamic v) => v)(status),
      'headers': ((dynamic v) => v.map((k, v) => MapEntry(k, v.map((v) => v).cast<String>().toList())).cast<String, List<String>>())(headers),
      'body': ((dynamic v) => v)(body),
    };
  }

  factory HttpResponse.fromMap(Map<String, dynamic> map) {
    return HttpResponse(
      status: ((dynamic v) => v)(map['status']),
      headers: ((dynamic v) => v.map((k, v) => MapEntry(k, v.map((v) => v).cast<String>().toList())).cast<String, List<String>>())(map['headers']),
      body: ((dynamic v) => v)(map['body']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HttpResponse.fromJson(String source) => HttpResponse.fromMap(json.decode(source));
}


class BuiltinClient {
  final FTLHttpClient ftlClient;

  BuiltinClient({required this.ftlClient});

}
