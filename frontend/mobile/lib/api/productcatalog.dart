// ignore_for_file: unused_import
library productcatalog;

import 'dart:convert';
import 'dart:typed_data';
import 'ftl_client.dart';
import 'builtin.dart' as builtin;
import 'currency.dart' as currency;


class ListRequest{

  ListRequest();

  Map<String, dynamic> toJson() {
    return {
    };
  }

  factory ListRequest.fromJson(Map<String, dynamic> map) {
    return ListRequest(
      
    );
  }
}

class Product{
  String id;
  String name;
  String description;
  String picture;
  currency.Money priceUSD;
  List<String> categories;

  Product({  required this.id,  required this.name,  required this.description,  required this.picture,  required this.priceUSD,  required this.categories,  });

  Map<String, dynamic> toJson() {
    return {
      'id': ((dynamic v) => v)(id),
      'name': ((dynamic v) => v)(name),
      'description': ((dynamic v) => v)(description),
      'picture': ((dynamic v) => v)(picture),
      'priceUSD': ((dynamic v) => v.toJson())(priceUSD),
      'categories': ((dynamic v) => v.map((v) => v).cast<String>().toList())(categories),
    };
  }

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: ((dynamic v) => v)(map['id']), name: ((dynamic v) => v)(map['name']), description: ((dynamic v) => v)(map['description']), picture: ((dynamic v) => v)(map['picture']), priceUSD: ((dynamic v) => currency.Money.fromJson(v))(map['priceUSD']), categories: ((dynamic v) => v.map((v) => v).cast<String>().toList())(map['categories']), 
    );
  }
}

class ListResponse{
  List<Product> products;

  ListResponse({  required this.products,  });

  Map<String, dynamic> toJson() {
    return {
      'products': ((dynamic v) => v.map((v) => v.toJson()).cast<Product>().toList())(products),
    };
  }

  factory ListResponse.fromJson(Map<String, dynamic> map) {
    return ListResponse(
      products: ((dynamic v) => v.map((v) => Product.fromJson(v)).cast<Product>().toList())(map['products']), 
    );
  }
}

class GetRequest{
  String id;

  GetRequest({  required this.id,  });

  Map<String, dynamic> toJson() {
    return {
      'id': ((dynamic v) => v)(id),
    };
  }

  factory GetRequest.fromJson(Map<String, dynamic> map) {
    return GetRequest(
      id: ((dynamic v) => v)(map['id']), 
    );
  }
}

class SearchRequest{
  String query;

  SearchRequest({  required this.query,  });

  Map<String, dynamic> toJson() {
    return {
      'query': ((dynamic v) => v)(query),
    };
  }

  factory SearchRequest.fromJson(Map<String, dynamic> map) {
    return SearchRequest(
      query: ((dynamic v) => v)(map['query']), 
    );
  }
}

class SearchResponse{
  List<Product> results;

  SearchResponse({  required this.results,  });

  Map<String, dynamic> toJson() {
    return {
      'results': ((dynamic v) => v.map((v) => v.toJson()).cast<Product>().toList())(results),
    };
  }

  factory SearchResponse.fromJson(Map<String, dynamic> map) {
    return SearchResponse(
      results: ((dynamic v) => v.map((v) => Product.fromJson(v)).cast<Product>().toList())(map['results']), 
    );
  }
}


class ProductcatalogClient {
  final FTLHttpClient ftlClient;

  ProductcatalogClient({required this.ftlClient});


  Future<ListResponse> list(
    ListRequest request, { 
    Map<String, String>? headers,
  }) async {
    final response = await ftlClient.get(
      '/productcatalog', 
      requestJson: json.encode(request.toJson()),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));
      return ListResponse.fromJson(body);
    } else {
      throw Exception('Failed to get list response');
    }
  }

  Future<Product> get(
    GetRequest request, { 
    Map<String, String>? headers,
  }) async {
    final response = await ftlClient.get(
      '/productcatalog/id', 
      requestJson: json.encode(request.toJson()),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));
      return Product.fromJson(body);
    } else {
      throw Exception('Failed to get get response');
    }
  }
}
