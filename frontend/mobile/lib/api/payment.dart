library ad;

import 'dart:convert';
import 'ftl_client.dart';


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

class ChargeRequest {
  Money amount;
  CreditCardInfo creditCard;

  ChargeRequest({ required this.amount, required this.creditCard,  });

  Map<String, dynamic> toMap() {
    return {
      'amount': ((dynamic v) =>v.toMap())(amount),
      'creditCard': ((dynamic v) =>v.toMap())(creditCard),
    };
  }

  factory ChargeRequest.fromMap(Map<String, dynamic> map) {
    return ChargeRequest(
      amount: ((dynamic v) => Money.fromMap(v))(map['amount']),
      creditCard: ((dynamic v) => CreditCardInfo.fromMap(v))(map['creditCard']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChargeRequest.fromJson(String source) => ChargeRequest.fromMap(json.decode(source));
}

class ChargeResponse {
  String transactionID;

  ChargeResponse({ required this.transactionID,  });

  Map<String, dynamic> toMap() {
    return {
      'transactionID': ((dynamic v) =>v)(transactionID),
    };
  }

  factory ChargeResponse.fromMap(Map<String, dynamic> map) {
    return ChargeResponse(
      transactionID: ((dynamic v) => v)(map['transactionID']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChargeResponse.fromJson(String source) => ChargeResponse.fromMap(json.decode(source));
}


class PaymentClient {
  final FTLHttpClient ftlClient;

  PaymentClient({required this.ftlClient});


  Future<ChargeResponse> charge(ChargeRequest request) async {
    final response = await ftlClient.post('/payment/charge', request: request.toMap());
    if (response.statusCode == 200) {
      return ChargeResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to get charge response');
    }
  }
}
