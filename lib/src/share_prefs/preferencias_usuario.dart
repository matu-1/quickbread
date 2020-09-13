/*
  Recordar instalar el paquete de:
    shared_preferences:
  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...
*/

import 'package:quickbread/src/models/usuario_model.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/pages/login_page.dart';
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

  // devuelve la pagina de inicio cuando esta logeado o no
  String paginaInicio() {
    if (_prefs.getString('usuario') != null) {
      return HomePage.routeName;
    } else {
      return LoginPage.routeName;
    }
  }

  void logout(BuildContext context) {
    _prefs.remove('usuario');
    Navigator.pop(context);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(HomePage.routeName, (Route route) => false);
  }
}
