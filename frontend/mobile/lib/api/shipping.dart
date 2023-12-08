// ignore_for_file: unused_import
library shipping;

import 'dart:convert';
import 'ftl_client.dart';
import 'currency.dart' as currency;
import 'cart.dart' as cart;


class Address {
  String streetAddress;
  String city;
  String state;
  String country;
  int zipCode;

  Address({  required this.streetAddress,  required this.city,  required this.state,  required this.country,  required this.zipCode,  });

  Map<String, dynamic> toMap() {
    return {
      'streetAddress': ((dynamic v) => v)(streetAddress),
      'city': ((dynamic v) => v)(city),
      'state': ((dynamic v) => v)(state),
      'country': ((dynamic v) => v)(country),
      'zipCode': ((dynamic v) => v)(zipCode),
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

class ShippingRequest {
  Address address;
  List<cart.Item> items;

  ShippingRequest({  required this.address,  required this.items,  });

  Map<String, dynamic> toMap() {
    return {
      'address': ((dynamic v) => v.toMap())(address),
      'items': ((dynamic v) => v.map((v) => cart.Item.fromMap(v)).cast<cart.Item>().toList())(items),
    };
  }

  factory ShippingRequest.fromMap(Map<String, dynamic> map) {
    return ShippingRequest(
      address: ((dynamic v) => Address.fromMap(v))(map['address']),
      items: ((dynamic v) => v.map((v) => cart.Item.fromMap(v)).cast<cart.Item>().toList())(map['items']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShippingRequest.fromJson(String source) => ShippingRequest.fromMap(json.decode(source));
}

class ShipOrderResponse {
  String id;

  ShipOrderResponse({  required this.id,  });

  Map<String, dynamic> toMap() {
    return {
      'id': ((dynamic v) => v)(id),
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


  Future<currency.Money> getQuote(ShippingRequest request) async {
    final response = await ftlClient.post('/shipping/quote', request: request.toMap());
    if (response.statusCode == 200) {
      return currency.Money.fromJson(response.body);
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
