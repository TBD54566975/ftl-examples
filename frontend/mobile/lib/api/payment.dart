// ignore_for_file: unused_import
library payment;

import 'dart:convert';
import 'dart:typed_data';
import 'ftl_client.dart';
import 'builtin.dart' as builtin;
import 'currency.dart' as currency;


class CreditCardInfo{
  String number;
  int cVV;
  int expirationYear;
  int expirationMonth;

  CreditCardInfo({  required this.number,  required this.cVV,  required this.expirationYear,  required this.expirationMonth,  });

  Map<String, dynamic> toJson() {
    return {
      'number': ((dynamic v) => v)(number),
      'cVV': ((dynamic v) => v)(cVV),
      'expirationYear': ((dynamic v) => v)(expirationYear),
      'expirationMonth': ((dynamic v) => v)(expirationMonth),
    };
  }

  factory CreditCardInfo.fromJson(Map<String, dynamic> map) {
    return CreditCardInfo(
      number: ((dynamic v) => v)(map['number']), cVV: ((dynamic v) => v)(map['cVV']), expirationYear: ((dynamic v) => v)(map['expirationYear']), expirationMonth: ((dynamic v) => v)(map['expirationMonth']), 
    );
  }
}

class ChargeRequest{
  currency.Money amount;
  CreditCardInfo creditCard;

  ChargeRequest({  required this.amount,  required this.creditCard,  });

  Map<String, dynamic> toJson() {
    return {
      'amount': ((dynamic v) => v.toJson())(amount),
      'creditCard': ((dynamic v) => v.toJson())(creditCard),
    };
  }

  factory ChargeRequest.fromJson(Map<String, dynamic> map) {
    return ChargeRequest(
      amount: ((dynamic v) => currency.Money.fromJson(v))(map['amount']), creditCard: ((dynamic v) => CreditCardInfo.fromJson(v))(map['creditCard']), 
    );
  }
}

class ChargeResponse{
  String transactionID;

  ChargeResponse({  required this.transactionID,  });

  Map<String, dynamic> toJson() {
    return {
      'transactionID': ((dynamic v) => v)(transactionID),
    };
  }

  factory ChargeResponse.fromJson(Map<String, dynamic> map) {
    return ChargeResponse(
      transactionID: ((dynamic v) => v)(map['transactionID']), 
    );
  }
}


class PaymentClient {
  final FTLHttpClient ftlClient;

  PaymentClient({required this.ftlClient});


  Future<ChargeResponse> charge(
    ChargeRequest request, { 
    Map<String, String>? headers,
  }) async {
    final response = await ftlClient.post('/payment/charge', request: request.toJson());
    if (response.statusCode == 200) {
      final body = json.decode(utf8.decode(response.bodyBytes));
      return ChargeResponse.fromJson(body);
    } else {
      throw Exception('Failed to get charge response');
    }
  }
}
