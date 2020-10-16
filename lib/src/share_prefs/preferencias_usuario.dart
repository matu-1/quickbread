/*
  Recordar instalar el paquete de:
    shared_preferences:
  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...
*/

import 'package:quickbread/src/models/ubicacion_model.dart';
import 'package:quickbread/src/models/usuario_model.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/pages/login_page.dart';
import 'package:quickbread/src/pages/pedido_ubicacion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();
  SharedPreferences _prefs;

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del usuario
  UsuarioModel get usuario {
    if (_prefs.getString('usuario') == null) return null;
    return usuarioModelFromJson(_prefs.getString('usuario'));
  }

  set usuario(UsuarioModel usuario) {
    _prefs.setString('usuario', usuarioModelToJson(usuario));
  }

  // GET y SET del token
  String get token {
    return _prefs.getString('token');
  }

  set token(String token) {
    _prefs.setString('token', token);
  }

  // GET y SET ubicacion
  UbicacionModel get ubicacion {
    if (_prefs.getString('ubicacion') == null) return null;
    return UbicacionModel.ubicacionFromJson(_prefs.getString('ubicacion'));
  }

  set ubicacion(UbicacionModel ubicacion) {
    _prefs.setString('ubicacion', UbicacionModel.ubicacionToJson(ubicacion));
  }

  // devuelve la pagina de inicio cuando esta logeado o no
  String paginaInicio() {
    if (_prefs.getString('ubicacion') != null) {
      return HomePage.routeName;
    } else {
      return PedidoUbicacion.routeName;
    }
  }

  void logout(BuildContext context) {
    _prefs.remove('usuario');
    Navigator.pop(context);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(HomePage.routeName, (Route route) => false);
  }
}
