import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:quickbread/src/constants/message_exception.dart';
import 'package:quickbread/src/constants/service.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';
import 'package:quickbread/src/utils/utils.dart';

class PedidoProvider {
  final _pref = new PreferenciasUsuario();

  Future<List<PedidoModel>> getAll() async {
    try {
      final response = await http
          .get(apiParam(Api.pedidoBySucursal, _pref.usuario.sucursalId));
      final respJson = json.decode(response.body);
      if (response.statusCode == 200) {
        return pedidosFromJsonList(respJson['data']);
      } else {
        throw Exception(respJson['message']);
      }
    } catch (e) {
      if (e.runtimeType == SocketOption)
        throw Exception(MessageException.noConnection);
      throw Exception(e.message);
    }
  }

  Future<List<PedidoModel>> getByCliente() async {
    int clienteId = _pref.usuario.id;
    try {
      final response = await http.get(apiParam(Api.pedidoByCliente, clienteId));
      final respJson = json.decode(response.body);
      if (response.statusCode == 200) {
        return pedidosFromJsonList(respJson['data']);
      } else {
        throw Exception(respJson['message']);
      }
    } catch (e) {
      if (e.runtimeType == SocketException)
        throw Exception(MessageException.noConnection);
      throw Exception(e.message);
    }
  }

  Future<Map> create(PedidoModel pedido) async {
    pedido.clienteId = _pref.usuario.id;
    pedido.setUbicacionSave(_pref.ubicacion);
    pedido.fechaHora = DateTime.now().toIso8601String();
    try {
      final response = await http
          .post(Api.pedidoListar, body: json.encode(pedido), headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });

      final respJson = json.decode(response.body);
      if (response.statusCode == 200) {
        return respJson;
      } else {
        throw Exception(respJson['message']);
      }
    } catch (e) {
      if (e.runtimeType == SocketException)
        throw Exception(MessageException.noConnection);
      throw Exception(e.message);
    }
  }

  Future<Map> setEntregado(int id) async {
    try {
      final response = await http.get(apiParam(Api.pedidoSetEntregado, id));
      final respJson = json.decode(response.body);
      if (response.statusCode == 200) {
        return respJson;
      } else {
        throw Exception(respJson['message']);
      }
    } catch (e) {
      if (e.runtimeType == SocketException)
        throw Exception(MessageException.noConnection);
      throw Exception(e.message);
    }
  }
}
