import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:quickbread/src/constants/message_exception.dart';
import 'package:quickbread/src/constants/service.dart';
import 'package:quickbread/src/models/usuario_model.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';
import 'package:quickbread/src/utils/utils.dart';

class UsuarioProvider {
  final _pref = new PreferenciasUsuario();

  Future<Map> create(UsuarioModel usuario) async {
    usuario.token = _pref.token;
    try {
      final response = await http.post(Api.clienteCreate,
          body: json.encode(usuario), headers: Api.requestHeader);

      final respJson = json.decode(response.body);
      if (response.statusCode == 200) {
        usuario.id = respJson['data']['idcliente'];
        _pref.usuario = usuario;
        return respJson;
      } else {
        throw Exception(respJson['message']);
      }
    } catch (e) {
      throw Exception(MessageException.noConnection);
    }
  }

  Future<Map> update(UsuarioModel usuario) async {
    print(usuario.toJson());
    try {
      final response = await http.put(
          apiParam(Api.usuarioUpdate, _pref.usuario.id),
          body: json.encode(usuario.toJsonUpdate()),
          headers: Api.requestHeader);

      final respJson = json.decode(response.body);
      if (response.statusCode == 200) {
        _pref.usuario = _pref.usuario..setUpdate(usuario);
        return respJson;
      } else {
        throw Exception(respJson['message']);
      }
    } catch (e) {
      if (e.runtimeType == SocketException) {
        throw Exception(MessageException.noConnection);
      }
      throw Exception(e.message);
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
        _pref.usuario = usuarioDB;
        print(_pref.usuario.toJson());
        updateToken();
        return respJson;
      } else {
        throw Exception(respJson['message']);
      }
    } catch (e) {
      if (e.runtimeType == SocketException) {
        throw Exception(MessageException.noConnection);
      }
      throw Exception(e.message);
    }
  }

  Future<Map> updateToken() async {
    try {
      final response = await http.post(Api.updateToken,
          body:
              json.encode({'email': _pref.usuario.email, 'token': _pref.token}),
          headers: Api.requestHeader);

      final respJson = json.decode(response.body);
      if (response.statusCode == 200) {
        return respJson;
      } else {
        throw Exception(respJson['message']);
      }
    } catch (e) {
      if (e.runtimeType == SocketException) {
        throw Exception(MessageException.noConnection);
      }
      throw Exception(e.message);
    }
  }
}
