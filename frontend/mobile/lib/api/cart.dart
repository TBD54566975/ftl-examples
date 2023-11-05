library ad;

import 'dart:convert';
import 'ftl_client.dart';


class Item {
  String productID;
  int quantity;

  Item({ required this.productID, required this.quantity,  });

  Map<String, dynamic> toMap() {
    return {
      'productID': ((dynamic v) =>v)(productID),
      'quantity': ((dynamic v) =>v)(quantity),
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      productID: ((dynamic v) => v)(map['productID']),
      quantity: ((dynamic v) => v)(map['quantity']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));
}

class AddItemRequest {
  String userID;
  Item item;

  AddItemRequest({ required this.userID, required this.item,  });

  Map<String, dynamic> toMap() {
    return {
      'userID': ((dynamic v) =>v)(userID),
      'item': ((dynamic v) =>v.toMap())(item),
    };
  }

  factory AddItemRequest.fromMap(Map<String, dynamic> map) {
    return AddItemRequest(
      userID: ((dynamic v) => v)(map['userID']),
      item: ((dynamic v) => Item.fromMap(v))(map['item']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddItemRequest.fromJson(String source) => AddItemRequest.fromMap(json.decode(source));
}

class AddItemResponse {

  AddItemResponse();

  Map<String, dynamic> toMap() {
    return {
    };
  }

  factory AddItemResponse.fromMap(Map<String, dynamic> map) {
    return AddItemResponse(
    );
  }

  String toJson() => json.encode(toMap());

  factory AddItemResponse.fromJson(String source) => AddItemResponse.fromMap(json.decode(source));
}

class GetCartRequest {
  String userID;

  GetCartRequest({ required this.userID,  });

  Map<String, dynamic> toMap() {
    return {
      'userID': ((dynamic v) =>v)(userID),
    };
  }

  factory GetCartRequest.fromMap(Map<String, dynamic> map) {
    return GetCartRequest(
      userID: ((dynamic v) => v)(map['userID']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetCartRequest.fromJson(String source) => GetCartRequest.fromMap(json.decode(source));
}

class Cart {
  String userID;
  List<Item> items;

  Cart({ required this.userID, required this.items,  });

  Map<String, dynamic> toMap() {
    return {
      'userID': ((dynamic v) =>v)(userID),
      'items': ((dynamic v) =>v.map((v) => Item.fromMap(v)).cast<Item>().toList())(items),
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      userID: ((dynamic v) => v)(map['userID']),
      items: ((dynamic v) => v.map((v) => Item.fromMap(v)).cast<Item>().toList())(map['items']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));
}

class EmptyCartRequest {
  String userID;

  EmptyCartRequest({ required this.userID,  });

  Map<String, dynamic> toMap() {
    return {
      'userID': ((dynamic v) =>v)(userID),
    };
  }

  factory EmptyCartRequest.fromMap(Map<String, dynamic> map) {
    return EmptyCartRequest(
      userID: ((dynamic v) => v)(map['userID']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EmptyCartRequest.fromJson(String source) => EmptyCartRequest.fromMap(json.decode(source));
}

class EmptyCartResponse {

  EmptyCartResponse();

  Map<String, dynamic> toMap() {
    return {
    };
  }

  factory EmptyCartResponse.fromMap(Map<String, dynamic> map) {
    return EmptyCartResponse(
    );
  }

  String toJson() => json.encode(toMap());

  factory EmptyCartResponse.fromJson(String source) => EmptyCartResponse.fromMap(json.decode(source));
}


class CartClient {
  final FTLHttpClient ftlClient;

  CartClient({required this.ftlClient});


  Future<AddItemResponse> addItem(AddItemRequest request) async {
    final response = await ftlClient.post('/cart/add', request: request.toMap());
    if (response.statusCode == 200) {
      return AddItemResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to get addItem response');
    }
  }

  Future<Cart> getCart(GetCartRequest request) async {
    final response = await ftlClient.get('/cart', request: request.toMap());
    if (response.statusCode == 200) {
      return Cart.fromJson(response.body);
    } else {
      throw Exception('Failed to get getCart response');
    }
  }

  Future<EmptyCartResponse> emptyCart(EmptyCartRequest request) async {
    final response = await ftlClient.post('/cart/empty', request: request.toMap());
    if (response.statusCode == 200) {
      return EmptyCartResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to get emptyCart response');
    }
  }
}
