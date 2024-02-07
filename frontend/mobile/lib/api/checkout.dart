// ignore_for_file: unused_import
library checkout;

import 'dart:convert';
import 'dart:typed_data';
import 'ftl_client.dart';
import 'builtin.dart' as builtin;
import 'cart.dart' as cart;
import 'currency.dart' as currency;
import 'payment.dart' as payment;
import 'productcatalog.dart' as productcatalog;
import 'shipping.dart' as shipping;


class PlaceOrderRequest{
  String userID;
  String userCurrency;
  shipping.Address address;
  String email;
  payment.CreditCardInfo creditCard;

  PlaceOrderRequest({  required this.userID,  required this.userCurrency,  required this.address,  required this.email,  required this.creditCard,  });

  Map<String, dynamic> toJson() {
    return {
      'userID': ((dynamic v) => v)(userID),
      'userCurrency': ((dynamic v) => v)(userCurrency),
      'address': ((dynamic v) => v.toJson())(address),
      'email': ((dynamic v) => v)(email),
      'creditCard': ((dynamic v) => v.toJson())(creditCard),
    };
  }

  factory PlaceOrderRequest.fromJson(Map<String, dynamic> map) {
    return PlaceOrderRequest(
      userID: ((dynamic v) => v)(map['userID']), userCurrency: ((dynamic v) => v)(map['userCurrency']), address: ((dynamic v) => shipping.Address.fromJson(v))(map['address']), email: ((dynamic v) => v)(map['email']), creditCard: ((dynamic v) => payment.CreditCardInfo.fromJson(v))(map['creditCard']), 
    );
  }
}

class OrderItem{
  cart.Item item;
  currency.Money cost;

  OrderItem({  required this.item,  required this.cost,  });

  Map<String, dynamic> toJson() {
    return {
      'item': ((dynamic v) => v.toJson())(item),
      'cost': ((dynamic v) => v.toJson())(cost),
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> map) {
    return OrderItem(
      item: ((dynamic v) => cart.Item.fromJson(v))(map['item']), cost: ((dynamic v) => currency.Money.fromJson(v))(map['cost']), 
    );
  }
}

class Order{
  String id;
  String shippingTrackingID;
  currency.Money shippingCost;
  shipping.Address shippingAddress;
  List<OrderItem> items;

  Order({  required this.id,  required this.shippingTrackingID,  required this.shippingCost,  required this.shippingAddress,  required this.items,  });

  Map<String, dynamic> toJson() {
    return {
      'id': ((dynamic v) => v)(id),
      'shippingTrackingID': ((dynamic v) => v)(shippingTrackingID),
      'shippingCost': ((dynamic v) => v.toJson())(shippingCost),
      'shippingAddress': ((dynamic v) => v.toJson())(shippingAddress),
      'items': ((dynamic v) => v.map((v) => v.toJson()).cast<OrderItem>().toList())(items),
    };
  }

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: ((dynamic v) => v)(map['id']), shippingTrackingID: ((dynamic v) => v)(map['shippingTrackingID']), shippingCost: ((dynamic v) => currency.Money.fromJson(v))(map['shippingCost']), shippingAddress: ((dynamic v) => shipping.Address.fromJson(v))(map['shippingAddress']), items: ((dynamic v) => v.map((v) => OrderItem.fromJson(v)).cast<OrderItem>().toList())(map['items']), 
    );
  }
}


class CheckoutClient {
  final FTLHttpClient ftlClient;

  CheckoutClient({required this.ftlClient});


  Future<Order> placeOrder(
    PlaceOrderRequest request, { 
    Map<String, String>? headers,
  }) async {
    final response = await ftlClient.post('/checkout/userID', request: request.toJson());
    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));
      return Order.fromJson(body);
    } else {
      throw Exception('Failed to get placeOrder response');
    }
  }

}
