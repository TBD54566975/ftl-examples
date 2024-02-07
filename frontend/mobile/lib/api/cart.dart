// ignore_for_file: unused_import
library cart;

import 'dart:convert';
import 'dart:typed_data';
import 'ftl_client.dart';
import 'builtin.dart' as builtin;


class Item{
  String productID;
  int quantity;

  Item({  required this.productID,  required this.quantity,  });

  Map<String, dynamic> toJson() {
    return {
      'productID': ((dynamic v) => v)(productID),
      'quantity': ((dynamic v) => v)(quantity),
    };
  }

  factory Item.fromJson(Map<String, dynamic> map) {
    return Item(
      productID: ((dynamic v) => v)(map['productID']), quantity: ((dynamic v) => v)(map['quantity']), 
    );
  }
}

class AddItemRequest{
  String userID;
  Item item;

  AddItemRequest({  required this.userID,  required this.item,  });

  Map<String, dynamic> toJson() {
    return {
      'userID': ((dynamic v) => v)(userID),
      'item': ((dynamic v) => v.toJson())(item),
    };
  }

  factory AddItemRequest.fromJson(Map<String, dynamic> map) {
    return AddItemRequest(
      userID: ((dynamic v) => v)(map['userID']), item: ((dynamic v) => Item.fromJson(v))(map['item']), 
    );
  }
}

class AddItemResponse{

  AddItemResponse();

  Map<String, dynamic> toJson() {
    return {
    };
  }

  factory AddItemResponse.fromJson(Map<String, dynamic> map) {
    return AddItemResponse(
      
    );
  }
}

class GetCartRequest{
  String userID;

  GetCartRequest({  required this.userID,  });

  Map<String, dynamic> toJson() {
    return {
      'userID': ((dynamic v) => v)(userID),
    };
  }

  factory GetCartRequest.fromJson(Map<String, dynamic> map) {
    return GetCartRequest(
      userID: ((dynamic v) => v)(map['userID']), 
    );
  }
}

class Cart{
  String userID;
  List<Item> items;

  Cart({  required this.userID,  required this.items,  });

  Map<String, dynamic> toJson() {
    return {
      'userID': ((dynamic v) => v)(userID),
      'items': ((dynamic v) => v.map((v) => v.toJson()).cast<Item>().toList())(items),
    };
  }

  factory Cart.fromJson(Map<String, dynamic> map) {
    return Cart(
      userID: ((dynamic v) => v)(map['userID']), items: ((dynamic v) => v.map((v) => Item.fromJson(v)).cast<Item>().toList())(map['items']), 
    );
  }
}

class EmptyCartRequest{
  String userID;

  EmptyCartRequest({  required this.userID,  });

  Map<String, dynamic> toJson() {
    return {
      'userID': ((dynamic v) => v)(userID),
    };
  }

  factory EmptyCartRequest.fromJson(Map<String, dynamic> map) {
    return EmptyCartRequest(
      userID: ((dynamic v) => v)(map['userID']), 
    );
  }
}

class EmptyCartResponse{

  EmptyCartResponse();

  Map<String, dynamic> toJson() {
    return {
    };
  }

  factory EmptyCartResponse.fromJson(Map<String, dynamic> map) {
    return EmptyCartResponse(
      
    );
  }
}


class CartClient {
  final FTLHttpClient ftlClient;

  CartClient({required this.ftlClient});


  Future<AddItemResponse> addItem(
    AddItemRequest request, { 
    Map<String, String>? headers,
  }) async {
    final response = await ftlClient.post('/cart/add', request: request.toJson());
    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));
      return AddItemResponse.fromJson(body);
    } else {
      throw Exception('Failed to get addItem response');
    }
  }

  Future<Cart> getCart(
    GetCartRequest request, { 
    Map<String, String>? headers,
  }) async {
    final response = await ftlClient.get(
      '/cart', 
      requestJson: json.encode(request.toJson()),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));
      return Cart.fromJson(body);
    } else {
      throw Exception('Failed to get getCart response');
    }
  }

  Future<EmptyCartResponse> emptyCart(
    EmptyCartRequest request, { 
    Map<String, String>? headers,
  }) async {
    final response = await ftlClient.post('/cart/empty', request: request.toJson());
    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));
      return EmptyCartResponse.fromJson(body);
    } else {
      throw Exception('Failed to get emptyCart response');
    }
  }
}
