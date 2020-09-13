import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quickbread/src/constants/service.dart';
import 'package:quickbread/src/models/message_exception.dart';
import 'package:quickbread/src/models/usuario_model.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';

class UsuarioProvider {
  final _pref = new PreferenciasUsuario();

  Future<Map> create(UsuarioModel usuario) async {
    usuario.token = _pref.token;
    try {
      final response = await http
          .post(Api.clienteCreate, body: json.encode(usuario), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });

      final respJson = json.decode(response.body);
      if (response.statusCode == 200) {
        usuario.id = respJson['data']['idcliente'];
        _pref.usuario = usuario;
        print(_pref.usuario.toJson());
        return respJson;
      } else {
        throw Exception(respJson['message']);
      }
    } catch (e) {
      throw Exception(MessageException.dbConection);
    }
  }

  Future<Map> login(UsuarioModel usuario) async {
    try {
      final response =
          await http.post(Api.login, body: json.encode(usuario), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });

      final respJson = json.decode(response.body);
      if (response.statusCode == 200) {
        final usuarioDB = UsuarioModel.fromJson(respJson['data']);
        usuarioDB.id = respJson['data']['idcliente'];
        _pref.usuario = usuarioDB;
        print(_pref.usuario.toJson());
        return respJson;
      } else {
        throw Exception(respJson['message']);
      }
    } catch (e) {
      throw Exception(MessageException.dbConection);
    }
  }
}
