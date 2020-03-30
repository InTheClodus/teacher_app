import 'package:parse_server_sdk/parse_server_sdk.dart';

//class OrderModel extends ParseObject implements ParseCloneable {
//
//  OrderModel() : super(_keyTableName);
//  OrderModel.clone(): this();
//
//  @override clone(Map map) => OrderModel.clone()..fromJson(map);
//
//  static const String _keyTableName = 'OrderInfo';
//  static const String keyorder = 'Order';
//
//
//  String get order => get<String>(keyorder);
//  set order(String order) => set<String>(keyorder, order);
//
//}

class OrderInfoModel{
  final String objectId;
  final num amount;
  final String drawee;
  final String draweePhone;
  final String receivingParty;
  final String receivingType;
  final String condescription;
  final DateTime createTiem;
  final String orderNumber;
  final String paymentMethod;

  OrderInfoModel(this.objectId,this.amount, this.drawee, this.draweePhone, this.receivingParty, this.receivingType, this.condescription, this.createTiem, this.orderNumber, this.paymentMethod);
}