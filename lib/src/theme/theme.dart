import 'package:flutter/material.dart';

Color primary = Color(0xff769BC4); //8e44ad
Color accent = Color(0xff5D7A9B); //6c5ce7

final ThemeData theme = ThemeData.light().copyWith(
    primaryColor: primary,
    accentColor: accent,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(color: Colors.white, elevation: 1),
    primaryTextTheme: ThemeData.light().primaryTextTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
    primaryIconTheme: ThemeData.light().primaryIconTheme.copyWith(
          color: Colors.black,
        ),
    tabBarTheme: ThemeData.light().tabBarTheme.copyWith(
        labelColor: primary,
        unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
            border: Border(bottom: BorderSide(width: 2, color: primary)))),
    floatingActionButtonTheme:
        ThemeData.light().floatingActionButtonTheme.copyWith(
              backgroundColor: accent,
            ));
