import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quickbread/src/constants/service.dart';
import 'package:quickbread/src/models/message_exception.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/models/producto_model.dart';
import 'package:quickbread/src/utils/utils.dart';

class PedidoProvider {
  Future<List<ProductoModel>> getAll() async {
    try {
      final response = await http.get(api['pedido']['listar']);
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return productosFromJsonList(data['data']);
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      throw Exception(MessageException.dbConection);
    }
  }

  Future<List<PedidoModel>> getByCliente() async {
    print(apiParam(Api.pedidoByCliente, 1));
    try {
      final response = await http.get(apiParam(Api.pedidoByCliente, 1));
      final respJson = json.decode(response.body);
      if (response.statusCode == 200) {
        return pedidosFromJsonList(respJson['data']);
      } else {
        throw Exception(respJson['message']);
      }
    } catch (e) {
      throw Exception(MessageException.dbConection);
    }
  }

  Future<Map> create(PedidoModel pedido) async {
    pedido.clienteId = 1;
    pedido.fechaHora = DateTime.now().toIso8601String();
    try {
      final response = await http
          .post(api['pedido']['listar'], body: json.encode(pedido), headers: {
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
      throw Exception(MessageException.dbConection);
    }
  }
}
