import 'package:online_boutique/api/productcatalog.dart';

String fromMoney(Money money) {
  return "${money.currencyCode} ${money.units}.${money.nanos.toString().padLeft(9, '0').substring(0, 2)}";
}
