import 'dart:io';

//import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teacher_app/server/ServiceLocator.dart';

import 'application/config.dart';
import 'main.dart';

void main() {
  setupLocator();
//  AMap.init('55aae5e170fb971f8a3c6d6f2a6b80df');
  Config.appFlavor = Flavor.RELEASE;
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  runApp(new MyApp());
}