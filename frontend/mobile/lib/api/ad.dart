library ad;

import 'dart:convert';
import 'ftl_client.dart';


class AdRequest {
  List<String> contextKeys;

  AdRequest({ required this.contextKeys,  });

  Map<String, dynamic> toMap() {
    return {
      'contextKeys': ((dynamic v) =>v.map((v) => v).cast<String>().toList())(contextKeys),
    };
  }

  factory AdRequest.fromMap(Map<String, dynamic> map) {
    return AdRequest(
      contextKeys: ((dynamic v) => v.map((v) => v).cast<String>().toList())(map['contextKeys']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AdRequest.fromJson(String source) => AdRequest.fromMap(json.decode(source));
}

class Ad {
  String redirectURL;
  String text;

  Ad({ required this.redirectURL, required this.text,  });

  Map<String, dynamic> toMap() {
    return {
      'redirectURL': ((dynamic v) =>v)(redirectURL),
      'text': ((dynamic v) =>v)(text),
    };
  }

  factory Ad.fromMap(Map<String, dynamic> map) {
    return Ad(
      redirectURL: ((dynamic v) => v)(map['redirectURL']),
      text: ((dynamic v) => v)(map['text']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Ad.fromJson(String source) => Ad.fromMap(json.decode(source));
}

class AdResponse {
  List<Ad> ads;

  AdResponse({ required this.ads,  });

  Map<String, dynamic> toMap() {
    return {
      'ads': ((dynamic v) =>v.map((v) => Ad.fromMap(v)).cast<Ad>().toList())(ads),
    };
  }

  factory AdResponse.fromMap(Map<String, dynamic> map) {
    return AdResponse(
      ads: ((dynamic v) => v.map((v) => Ad.fromMap(v)).cast<Ad>().toList())(map['ads']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AdResponse.fromJson(String source) => AdResponse.fromMap(json.decode(source));
}


class AdClient {
  final FTLHttpClient ftlClient;

  AdClient({required this.ftlClient});


  Future<AdResponse> get(AdRequest request) async {
    final response = await ftlClient.get('/ad', request: request.toMap());
    if (response.statusCode == 200) {
      return AdResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to get get response');
    }
  }
}
