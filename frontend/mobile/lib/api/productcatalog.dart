library ad;

import 'dart:convert';
import 'ftl_client.dart';


class ListRequest {

  ListRequest();

  Map<String, dynamic> toMap() {
    return {
    };
  }

  factory ListRequest.fromMap(Map<String, dynamic> map) {
    return ListRequest(
    );
  }

  String toJson() => json.encode(toMap());

  factory ListRequest.fromJson(String source) => ListRequest.fromMap(json.decode(source));
}

class Money {
  String currencyCode;
  int units;
  int nanos;

  Money({ required this.currencyCode, required this.units, required this.nanos,  });

  Map<String, dynamic> toMap() {
    return {
      'currencyCode': ((dynamic v) =>v)(currencyCode),
      'units': ((dynamic v) =>v)(units),
      'nanos': ((dynamic v) =>v)(nanos),
    };
  }

  factory Money.fromMap(Map<String, dynamic> map) {
    return Money(
      currencyCode: ((dynamic v) => v)(map['currencyCode']),
      units: ((dynamic v) => v)(map['units']),
      nanos: ((dynamic v) => v)(map['nanos']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Money.fromJson(String source) => Money.fromMap(json.decode(source));
}

class Product {
  String id;
  String name;
  String description;
  String picture;
  Money priceUSD;
  List<String> categories;

  Product({ required this.id, required this.name, required this.description, required this.picture, required this.priceUSD, required this.categories,  });

  Map<String, dynamic> toMap() {
    return {
      'id': ((dynamic v) =>v)(id),
      'name': ((dynamic v) =>v)(name),
      'description': ((dynamic v) =>v)(description),
      'picture': ((dynamic v) =>v)(picture),
      'priceUSD': ((dynamic v) =>v.toMap())(priceUSD),
      'categories': ((dynamic v) =>v.map((v) => v).cast<String>().toList())(categories),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: ((dynamic v) => v)(map['id']),
      name: ((dynamic v) => v)(map['name']),
      description: ((dynamic v) => v)(map['description']),
      picture: ((dynamic v) => v)(map['picture']),
      priceUSD: ((dynamic v) => Money.fromMap(v))(map['priceUSD']),
      categories: ((dynamic v) => v.map((v) => v).cast<String>().toList())(map['categories']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));
}

class ListResponse {
  List<Product> products;

  ListResponse({ required this.products,  });

  Map<String, dynamic> toMap() {
    return {
      'products': ((dynamic v) =>v.map((v) => Product.fromMap(v)).cast<Product>().toList())(products),
    };
  }

  factory ListResponse.fromMap(Map<String, dynamic> map) {
    return ListResponse(
      products: ((dynamic v) => v.map((v) => Product.fromMap(v)).cast<Product>().toList())(map['products']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListResponse.fromJson(String source) => ListResponse.fromMap(json.decode(source));
}

class GetRequest {
  String id;

  GetRequest({ required this.id,  });

  Map<String, dynamic> toMap() {
    return {
      'id': ((dynamic v) =>v)(id),
    };
  }

  factory GetRequest.fromMap(Map<String, dynamic> map) {
    return GetRequest(
      id: ((dynamic v) => v)(map['id']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetRequest.fromJson(String source) => GetRequest.fromMap(json.decode(source));
}

class SearchRequest {
  String query;

  SearchRequest({ required this.query,  });

  Map<String, dynamic> toMap() {
    return {
      'query': ((dynamic v) =>v)(query),
    };
  }

  factory SearchRequest.fromMap(Map<String, dynamic> map) {
    return SearchRequest(
      query: ((dynamic v) => v)(map['query']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchRequest.fromJson(String source) => SearchRequest.fromMap(json.decode(source));
}

class SearchResponse {
  List<Product> results;

  SearchResponse({ required this.results,  });

  Map<String, dynamic> toMap() {
    return {
      'results': ((dynamic v) =>v.map((v) => Product.fromMap(v)).cast<Product>().toList())(results),
    };
  }

  factory SearchResponse.fromMap(Map<String, dynamic> map) {
    return SearchResponse(
      results: ((dynamic v) => v.map((v) => Product.fromMap(v)).cast<Product>().toList())(map['results']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchResponse.fromJson(String source) => SearchResponse.fromMap(json.decode(source));
}


class ProductcatalogClient {
  final FTLHttpClient ftlClient;

  ProductcatalogClient({required this.ftlClient});


  Future<ListResponse> list(ListRequest request) async {
    final response = await ftlClient.get('/productcatalog', request: request.toMap());
    if (response.statusCode == 200) {
      return ListResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to get list response');
    }
  }

  Future<Product> get(GetRequest request) async {
    final response = await ftlClient.get('/productcatalog/id', request: request.toMap());
    if (response.statusCode == 200) {
      return Product.fromJson(response.body);
    } else {
      throw Exception('Failed to get get response');
    }
  }
}
