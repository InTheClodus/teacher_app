import 'package:flutter/material.dart';
import 'package:teacher_app/tab/Tabs.dart';

import '../logon_status.dart';

/*
* 路由統一管理
* */
final routes={
  '/':(context)=>DecisionPage(),
//  '/loginsuccess':(context)=>Tab(),
//  '/form':(context)=>FormPage(),
//  '/search':(context,{arguments})=>SearchPage(arguments:arguments),
};
//固定写法
var onGenerateRoute=(RouteSettings settings) {
  // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    }else{
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context));
      return route;
    }
  }
};