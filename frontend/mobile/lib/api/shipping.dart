library ad;

import 'dart:convert';
import 'ftl_client.dart';


class Address {
  String streetAddress;
  String city;
  String state;
  String country;
  int zipCode;

  Address({ required this.streetAddress, required this.city, required this.state, required this.country, required this.zipCode,  });

  Map<String, dynamic> toMap() {
    return {
      'streetAddress': ((dynamic v) =>v)(streetAddress),
      'city': ((dynamic v) =>v)(city),
      'state': ((dynamic v) =>v)(state),
      'country': ((dynamic v) =>v)(country),
      'zipCode': ((dynamic v) =>v)(zipCode),
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      streetAddress: ((dynamic v) => v)(map['streetAddress']),
      city: ((dynamic v) => v)(map['city']),
      state: ((dynamic v) => v)(map['state']),
      country: ((dynamic v) => v)(map['country']),
      zipCode: ((dynamic v) => v)(map['zipCode']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) => Address.fromMap(json.decode(source));
}

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

class ShippingRequest {
  Address address;
  List<Item> items;

  ShippingRequest({ required this.address, required this.items,  });

  Map<String, dynamic> toMap() {
    return {
      'address': ((dynamic v) =>v.toMap())(address),
      'items': ((dynamic v) =>v.map((v) => Item.fromMap(v)).cast<Item>().toList())(items),
    };
  }

  factory ShippingRequest.fromMap(Map<String, dynamic> map) {
    return ShippingRequest(
      address: ((dynamic v) => Address.fromMap(v))(map['address']),
      items: ((dynamic v) => v.map((v) => Item.fromMap(v)).cast<Item>().toList())(map['items']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShippingRequest.fromJson(String source) => ShippingRequest.fromMap(json.decode(source));
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

class ShipOrderResponse {
  String id;

  ShipOrderResponse({ required this.id,  });

  Map<String, dynamic> toMap() {
    return {
      'id': ((dynamic v) =>v)(id),
    };
  }

  factory ShipOrderResponse.fromMap(Map<String, dynamic> map) {
    return ShipOrderResponse(
      id: ((dynamic v) => v)(map['id']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShipOrderResponse.fromJson(String source) => ShipOrderResponse.fromMap(json.decode(source));
}


class ShippingClient {
  final FTLHttpClient ftlClient;

  ShippingClient({required this.ftlClient});


  Future<Money> getQuote(ShippingRequest request) async {
    final response = await ftlClient.post('/shipping/quote', request: request.toMap());
    if (response.statusCode == 200) {
      return Money.fromJson(response.body);
    } else {
      throw Exception('Failed to get getQuote response');
    }
  }

  Future<ShipOrderResponse> shipOrder(ShippingRequest request) async {
    final response = await ftlClient.post('/shipping/ship', request: request.toMap());
    if (response.statusCode == 200) {
      return ShipOrderResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to get shipOrder response');
    }
  }
}
