import 'package:flutter/material.dart';

Color primary = Color(0xff8e44ad);
Color accent = Color(0xffe74c3c);

final ThemeData theme = ThemeData.light().copyWith(
    primaryColor: primary,
    accentColor: accent,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(color: primary),
    floatingActionButtonTheme:
        ThemeData.light().floatingActionButtonTheme.copyWith(
              backgroundColor: accent,
            ));
