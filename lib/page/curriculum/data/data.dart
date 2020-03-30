import 'package:flutter/material.dart';

class Doodle {
  final String tea;
  final String name;
  final String time;
  final String address;
  final String doodle;
  final Color iconBackground;
  final Icon icon;
  const Doodle({
        this.tea,
        this.name,
        this.time,
        this.address,
        this.doodle,
        this.icon,
        this.iconBackground});
}

const List<Doodle> doodles = [
  Doodle(
      name: "珠心算",
      time: "14：00",
      address:
      "教業中學附屬小學暨幼稚園分校",
      doodle:
      "https://www.google.com/logos/doodles/2016/abd-al-rahman-al-sufis-azophi-1113th-birthday-5115602948587520-hp2x.jpg",
      icon: Icon(Icons.radio_button_unchecked, color: Colors.cyan),
      iconBackground: Colors.cyan),
  Doodle(
      name: "珠心算",
      time: "16：00",
      address: "培道中學(乙水)仔小學分校",
      doodle:
      "https://www.google.com/logos/doodles/2015/abu-al-wafa-al-buzjanis-1075th-birthday-5436382608621568-hp2x.jpg",
      icon: Icon(
        Icons.radio_button_unchecked,
        color: Colors.cyan,
      ),
      iconBackground: Colors.cyan),
  Doodle(
      name: "身心語言程式學",
      time: "17：00",
      address: "鮑思高粵華小學（英文部）",
      doodle:
      "https://lh3.googleusercontent.com/ZTlbHDpH59p-aH2h3ggUdhByhuq1AfviGuoQpt3QqaC7bROzbKuARKeEfggkjRmAwfB1p4yKbcjPusNDNIE9O7STbc9C0SAU0hmyTjA=s660",
      icon: Icon(
        Icons.radio_button_unchecked,
        color: Colors.cyan,
        size: 32.0,
      ),
      iconBackground: Colors.cyan),
  Doodle(
      name: "身心語言程式學",
      time: "18：00",
      address: "聖公會(澳門)蔡高中學(分校)",
      doodle:
      "https://lh3.googleusercontent.com/bFwiXFZEum_vVibMzkgPlaKZMDc66W-S_cz1aPKbU0wyNzL_ucN_kXzjOlygywvf6Bcn3ipSLTsszGieEZTLKn9NHXnw8VJs4-xU6Br9cg=s660",
      icon: Icon(
        Icons.radio_button_unchecked,
        color: Colors.cyan,
      ),
      iconBackground: Colors.cyan),
];