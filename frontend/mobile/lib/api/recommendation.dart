library ad;

import 'dart:convert';
import 'ftl_client.dart';


class ListRequest {
  String userID;
  List<String> userProductIDs;

  ListRequest({ required this.userID, required this.userProductIDs,  });

  Map<String, dynamic> toMap() {
    return {
      'userID': ((dynamic v) =>v)(userID),
      'userProductIDs': ((dynamic v) =>v.map((v) => v).cast<String>().toList())(userProductIDs),
    };
  }

  factory ListRequest.fromMap(Map<String, dynamic> map) {
    return ListRequest(
      userID: ((dynamic v) => v)(map['userID']),
      userProductIDs: ((dynamic v) => v.map((v) => v).cast<String>().toList())(map['userProductIDs']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListRequest.fromJson(String source) => ListRequest.fromMap(json.decode(source));
}

class ListResponse {
  List<String> productIDs;

  ListResponse({ required this.productIDs,  });

  Map<String, dynamic> toMap() {
    return {
      'productIDs': ((dynamic v) =>v.map((v) => v).cast<String>().toList())(productIDs),
    };
  }

  factory ListResponse.fromMap(Map<String, dynamic> map) {
    return ListResponse(
      productIDs: ((dynamic v) => v.map((v) => v).cast<String>().toList())(map['productIDs']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListResponse.fromJson(String source) => ListResponse.fromMap(json.decode(source));
}


class RecommendationClient {
  final FTLHttpClient ftlClient;

  RecommendationClient({required this.ftlClient});


  Future<ListResponse> list(ListRequest request) async {
    final response = await ftlClient.get('/recommendation', request: request.toMap());
    if (response.statusCode == 200) {
      return ListResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to get list response');
    }
  }

}
