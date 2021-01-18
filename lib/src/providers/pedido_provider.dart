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

  Future<List<PedidoModel>> getAll(String estado) async {
    try {
      final response = await http.get(
          '${apiParam(Api.pedidoByEmpleadoListar, _pref.usuario.id)}?estado=$estado');
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
        this.sendNotificationAdmin();
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

  Future<void> sendNotificationAdmin() async {
    try {
      final response = await http
          .get(apiParam(Api.usuarioPersonalListar, _pref.usuario.sucursalId));
      final respJson = json.decode(response.body);
      if (response.statusCode == 200) {
        final personales = respJson['data'];
        personales.forEach((personal) {
          final roles = personal['user']['roles'];
          if (personal['token'] != null && roles != null && roles[0]['name'] != 'repartidor')
            sendNotification(personal['token'],
                'Tienes un nuevo pedido, dale una mirada', 'Pedido nuevo', {});
        });
      } else {
        throw Exception(respJson['message']);
      }
    } catch (e) {
      if (e.runtimeType == SocketOption)
        throw Exception(MessageException.noConnection);
      throw Exception(e.message);
    }
  }

  static Future<Map> sendNotification(
      String token, String message, String title, Map data) async {
    final url = 'https://fcm.googleapis.com/fcm/send';
    final keyServer =
        'AAAAaCDI5Xs:APA91bERZTbtiYzQJD0U8AcWkgfThxDgef5f4fWvSgrbsq0fQzlaOo068vKIgZX2wzJA6KDT5pTtIUR-N425mwjDYtnSViRyeTZsdCo-l6oQh2XUKBG8FuV1pnHI8rUMRGC8W0R0Ojko';

    final body = {
      "to": token,
      "notification": {"body": message, "title": title},
      "data": data ?? {}
    };

    try {
      final resp = await http.post(url,
          body: json.encode(body),
          headers: {...Api.requestHeader, 'Authorization': 'key=$keyServer'});
      final data = json.decode(resp.body);
      return data;
    } catch (e) {
      throw Exception(MessageException.noResult);
    }
  }
}
