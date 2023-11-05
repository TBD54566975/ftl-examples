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

class CreditCardInfo {
  String number;
  int cVV;
  int expirationYear;
  int expirationMonth;

  CreditCardInfo({ required this.number, required this.cVV, required this.expirationYear, required this.expirationMonth,  });

  Map<String, dynamic> toMap() {
    return {
      'number': ((dynamic v) =>v)(number),
      'cVV': ((dynamic v) =>v)(cVV),
      'expirationYear': ((dynamic v) =>v)(expirationYear),
      'expirationMonth': ((dynamic v) =>v)(expirationMonth),
    };
  }

  factory CreditCardInfo.fromMap(Map<String, dynamic> map) {
    return CreditCardInfo(
      number: ((dynamic v) => v)(map['number']),
      cVV: ((dynamic v) => v)(map['cVV']),
      expirationYear: ((dynamic v) => v)(map['expirationYear']),
      expirationMonth: ((dynamic v) => v)(map['expirationMonth']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreditCardInfo.fromJson(String source) => CreditCardInfo.fromMap(json.decode(source));
}

class PlaceOrderRequest {
  String userID;
  String userCurrency;
  Address address;
  String email;
  CreditCardInfo creditCard;

  PlaceOrderRequest({ required this.userID, required this.userCurrency, required this.address, required this.email, required this.creditCard,  });

  Map<String, dynamic> toMap() {
    return {
      'userID': ((dynamic v) =>v)(userID),
      'userCurrency': ((dynamic v) =>v)(userCurrency),
      'address': ((dynamic v) =>v.toMap())(address),
      'email': ((dynamic v) =>v)(email),
      'creditCard': ((dynamic v) =>v.toMap())(creditCard),
    };
  }

  factory PlaceOrderRequest.fromMap(Map<String, dynamic> map) {
    return PlaceOrderRequest(
      userID: ((dynamic v) => v)(map['userID']),
      userCurrency: ((dynamic v) => v)(map['userCurrency']),
      address: ((dynamic v) => Address.fromMap(v))(map['address']),
      email: ((dynamic v) => v)(map['email']),
      creditCard: ((dynamic v) => CreditCardInfo.fromMap(v))(map['creditCard']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceOrderRequest.fromJson(String source) => PlaceOrderRequest.fromMap(json.decode(source));
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

class OrderItem {
  Item item;
  Money cost;

  OrderItem({ required this.item, required this.cost,  });

  Map<String, dynamic> toMap() {
    return {
      'item': ((dynamic v) =>v.toMap())(item),
      'cost': ((dynamic v) =>v.toMap())(cost),
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      item: ((dynamic v) => Item.fromMap(v))(map['item']),
      cost: ((dynamic v) => Money.fromMap(v))(map['cost']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) => OrderItem.fromMap(json.decode(source));
}

class Order {
  String id;
  String shippingTrackingID;
  Money shippingCost;
  Address shippingAddress;
  List<OrderItem> items;

  Order({ required this.id, required this.shippingTrackingID, required this.shippingCost, required this.shippingAddress, required this.items,  });

  Map<String, dynamic> toMap() {
    return {
      'id': ((dynamic v) =>v)(id),
      'shippingTrackingID': ((dynamic v) =>v)(shippingTrackingID),
      'shippingCost': ((dynamic v) =>v.toMap())(shippingCost),
      'shippingAddress': ((dynamic v) =>v.toMap())(shippingAddress),
      'items': ((dynamic v) =>v.map((v) => OrderItem.fromMap(v)).cast<OrderItem>().toList())(items),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: ((dynamic v) => v)(map['id']),
      shippingTrackingID: ((dynamic v) => v)(map['shippingTrackingID']),
      shippingCost: ((dynamic v) => Money.fromMap(v))(map['shippingCost']),
      shippingAddress: ((dynamic v) => Address.fromMap(v))(map['shippingAddress']),
      items: ((dynamic v) => v.map((v) => OrderItem.fromMap(v)).cast<OrderItem>().toList())(map['items']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}


class CheckoutClient {
  final FTLHttpClient ftlClient;

  CheckoutClient({required this.ftlClient});


  Future<Order> placeOrder(PlaceOrderRequest request) async {
    final response = await ftlClient.post('/checkout', request: request.toMap());
    if (response.statusCode == 200) {
      return Order.fromJson(response.body);
    } else {
      throw Exception('Failed to get placeOrder response');
    }
  }

}
