import 'package:flutter/material.dart';

/*
* 樣式
* */
class Style {
  /// Returns a random color.
  static Color next(_str) {
    if (_str == "A") {
      return Color(0xFF01A6FF);
    }
    if (_str == "P") {
      return Color(0x00FF0087CF);
    }
    if (_str == "N") {
      return Color(0x00FF006093);
    }
    if (_str == "O") {
      return Color(0x00FFF95F62);
    }
    if (_str == "PH") {
      return Color(0x00FFF95F62);
    }
    if (_str == "AL") {
      return Color(0x00FFF95F62);
    }
    if (_str == "BT") {
      return Color(0x00FF976DD0);
    }
    if (_str == "KW") {
      return Color(0x00FFB8977E);
    }
    if (_str == "SL") {
      return Color(0x00FF6DD0D0);
    }
    if (_str == "交易成功") {
      return Color(0xfff68d07);
    }
    if (_str == "待收款") {
      return Color(0xfff54428);
    }
    if (_str == "退出登錄") {
      return Color(0xfff54428);
    }
    if (_str == "請假") {
      return Color(0xff76EEC6);
    }
    if (_str == "出席") {
      return Color(0xff00affe);
    }
    if (_str == "缺席") {
      return Color(0xffff4500);
    }
    if (_str == "遲到") {
      return Color(0xffEE7621);
    } else {
      return Color(0xff6a6a6a);
    }
  }
}
