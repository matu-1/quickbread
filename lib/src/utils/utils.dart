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

String getDateShort(DateTime fecha) {
  return '${dias[fecha.weekday - 1]}, ${fecha.day} de ${meses[fecha.month - 1]}';
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

String tiempoTranscurrido(DateTime fecha) {
  DateTime ahora = DateTime.now();
  final diff = ahora.difference(fecha);
  if (diff.inMinutes == 0) {
    return 'Hace un momento';
  } else if (diff.inMinutes <= 60) {
    return 'Hace ${diff.inMinutes} minutos';
  } else if (diff.inHours <= 60) {
    return '${diff.inHours} horas atras';
  } else if (diff.inDays <= 30) {
    return 'Hace ${diff.inDays} dias';
  } else {
    return '${fecha.day} de ${meses[fecha.month + 1]}, ${fecha.year}';
  }
}

String capitalize(String cadena) =>
    cadena[0].toUpperCase() + cadena.substring(1);
