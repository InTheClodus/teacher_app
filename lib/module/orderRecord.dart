import 'package:parse_server_sdk/parse_server_sdk.dart';

class OrderRecord{
  final String objectId;
  final String orderName;
  final DateTime orderDate;
  final int orderPrice;
  final String orderStatus;

  OrderRecord(this.objectId,this.orderName, this.orderDate, this.orderPrice, this.orderStatus);
}

class OrderRecords extends ParseObject implements ParseCloneable {

  OrderRecords() : super(_keyTableName);
  OrderRecords.clone(): this();

  @override clone(Map map) => OrderRecords.clone()..fromJson(map);

  static const String _keyTableName = 'OrderRecord';
  static const String keyName = 'OrderName';
  static const String keyDate='OrderDate';
  static const String keyPrice='OrderPrice';
  static const String keyStatus='OrderStatus';

  String get name => get<String>(keyName);
  set name(String name) => set<String>(keyName, name);

  String get date=>get<String>(keyDate);
  set date(String date)=>set<String>(keyDate,date);

  String get price=>get<String>(keyPrice);
  set price(String price)=>set<String>(keyPrice,price);

  String get status=>get<String>(keyStatus);
  set status(String status)=>set<String>(keyStatus,status);
}