library ad;

import 'dart:convert';
import 'ftl_client.dart';


class GetSupportedCurrenciesRequest {

  GetSupportedCurrenciesRequest();

  Map<String, dynamic> toMap() {
    return {
    };
  }

  factory GetSupportedCurrenciesRequest.fromMap(Map<String, dynamic> map) {
    return GetSupportedCurrenciesRequest(
    );
  }

  String toJson() => json.encode(toMap());

  factory GetSupportedCurrenciesRequest.fromJson(String source) => GetSupportedCurrenciesRequest.fromMap(json.decode(source));
}

class GetSupportedCurrenciesResponse {
  List<String> currencyCodes;

  GetSupportedCurrenciesResponse({ required this.currencyCodes,  });

  Map<String, dynamic> toMap() {
    return {
      'currencyCodes': ((dynamic v) =>v.map((v) => v).cast<String>().toList())(currencyCodes),
    };
  }

  factory GetSupportedCurrenciesResponse.fromMap(Map<String, dynamic> map) {
    return GetSupportedCurrenciesResponse(
      currencyCodes: ((dynamic v) => v.map((v) => v).cast<String>().toList())(map['currencyCodes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetSupportedCurrenciesResponse.fromJson(String source) => GetSupportedCurrenciesResponse.fromMap(json.decode(source));
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

class ConvertRequest {
  Money from;
  String toCode;

  ConvertRequest({ required this.from, required this.toCode,  });

  Map<String, dynamic> toMap() {
    return {
      'from': ((dynamic v) =>v.toMap())(from),
      'toCode': ((dynamic v) =>v)(toCode),
    };
  }

  factory ConvertRequest.fromMap(Map<String, dynamic> map) {
    return ConvertRequest(
      from: ((dynamic v) => Money.fromMap(v))(map['from']),
      toCode: ((dynamic v) => v)(map['toCode']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConvertRequest.fromJson(String source) => ConvertRequest.fromMap(json.decode(source));
}


class CurrencyClient {
  final FTLHttpClient ftlClient;

  CurrencyClient({required this.ftlClient});


  Future<GetSupportedCurrenciesResponse> getSupportedCurrencies(GetSupportedCurrenciesRequest request) async {
    final response = await ftlClient.get('/currency/supported', request: request.toMap());
    if (response.statusCode == 200) {
      return GetSupportedCurrenciesResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to get getSupportedCurrencies response');
    }
  }

  Future<Money> convert(ConvertRequest request) async {
    final response = await ftlClient.post('/currency/convert', request: request.toMap());
    if (response.statusCode == 200) {
      return Money.fromJson(response.body);
    } else {
      throw Exception('Failed to get convert response');
    }
  }
}
