import 'dart:io';

//import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'application/config.dart';
import 'main.dart';
import 'server/ServiceLocator.dart';
void main() {
  setupLocator();
  if (Platform.isAndroid) {
//    debugPaintSizeEnabled = true;
    SystemUiOverlayStyle systemUiOverlayStyle =
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
//  AMap.init('55aae5e170fb971f8a3c6d6f2a6b80df');
  Config.appFlavor = Flavor.DEVELOPMENT;
  runApp(new MyApp());
}