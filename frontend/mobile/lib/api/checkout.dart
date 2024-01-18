// ignore_for_file: unused_import
library checkout;

import 'dart:convert';
import 'dart:typed_data';
import 'ftl_client.dart';
import 'cart.dart' as cart;
import 'currency.dart' as currency;
import 'payment.dart' as payment;
import 'productcatalog.dart' as productcatalog;
import 'shipping.dart' as shipping;


class PlaceOrderRequest {
  String userID;
  String userCurrency;
  shipping.Address address;
  String email;
  payment.CreditCardInfo creditCard;

  PlaceOrderRequest({  required this.userID,  required this.userCurrency,  required this.address,  required this.email,  required this.creditCard,  });

  Map<String, dynamic> toMap() {
    return {
      'userID': ((dynamic v) => v)(userID),
      'userCurrency': ((dynamic v) => v)(userCurrency),
      'address': ((dynamic v) => v.toMap())(address),
      'email': ((dynamic v) => v)(email),
      'creditCard': ((dynamic v) => v.toMap())(creditCard),
    };
  }

  factory PlaceOrderRequest.fromMap(Map<String, dynamic> map) {
    return PlaceOrderRequest(
      userID: ((dynamic v) => v)(map['userID']),
      userCurrency: ((dynamic v) => v)(map['userCurrency']),
      address: ((dynamic v) => shipping.Address.fromMap(v))(map['address']),
      email: ((dynamic v) => v)(map['email']),
      creditCard: ((dynamic v) => payment.CreditCardInfo.fromMap(v))(map['creditCard']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceOrderRequest.fromJson(String source) => PlaceOrderRequest.fromMap(json.decode(source));
}

class OrderItem {
  cart.Item item;
  currency.Money cost;

  OrderItem({  required this.item,  required this.cost,  });

  Map<String, dynamic> toMap() {
    return {
      'item': ((dynamic v) => v.toMap())(item),
      'cost': ((dynamic v) => v.toMap())(cost),
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      item: ((dynamic v) => cart.Item.fromMap(v))(map['item']),
      cost: ((dynamic v) => currency.Money.fromMap(v))(map['cost']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) => OrderItem.fromMap(json.decode(source));
}

class Order {
  String id;
  String shippingTrackingID;
  currency.Money shippingCost;
  shipping.Address shippingAddress;
  List<OrderItem> items;

  Order({  required this.id,  required this.shippingTrackingID,  required this.shippingCost,  required this.shippingAddress,  required this.items,  });

  Map<String, dynamic> toMap() {
    return {
      'id': ((dynamic v) => v)(id),
      'shippingTrackingID': ((dynamic v) => v)(shippingTrackingID),
      'shippingCost': ((dynamic v) => v.toMap())(shippingCost),
      'shippingAddress': ((dynamic v) => v.toMap())(shippingAddress),
      'items': ((dynamic v) => v.map((v) => v.toMap()).cast<OrderItem>().toList())(items),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: ((dynamic v) => v)(map['id']),
      shippingTrackingID: ((dynamic v) => v)(map['shippingTrackingID']),
      shippingCost: ((dynamic v) => currency.Money.fromMap(v))(map['shippingCost']),
      shippingAddress: ((dynamic v) => shipping.Address.fromMap(v))(map['shippingAddress']),
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
    final response = await ftlClient.post('/checkout/userID', request: request.toMap());
    if (response.statusCode == 200) {
      return Order.fromJson(response.body);
    } else {
      throw Exception('Failed to get placeOrder response');
    }
  }

}
