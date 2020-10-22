import 'package:flutter/material.dart';
import 'package:quickbread/src/constants/fecha.dart';

bool isEmail(String texto) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (regExp.hasMatch(texto)) {
    return true;
  } else {
    return false;
  }
}

bool isNumeric(String s) {
  if (s.isEmpty) return false;
  final numero = num.tryParse(s);
  return (numero == null) ? false : true;
}

String getFecha(DateTime fecha) {
  return '${dias[fecha.weekday - 1]}, ${fecha.day} de ${meses[fecha.month - 1]} del ${fecha.year}';
}

void showSnackbar(String message, GlobalKey<ScaffoldState> scaffoldKey) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: 2),
  ));
}

String apiParam(String route, dynamic param) {
  return route.replaceAll(':id', param.toString());
}

