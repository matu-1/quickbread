import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:quickbread/src/constants/message_exception.dart';
import 'package:quickbread/src/constants/service.dart';
import 'package:quickbread/src/models/sucursal_producto_model.dart';
import 'package:quickbread/src/utils/utils.dart';

class ProductoProvider {
  Future<List<SucursalProductoModel>> getAll(int id) async {
    try {
      final response = await http.get(apiParam(Api.productoSucursalListar, id));
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return SucursalProductoModel.fromJsonList(data['data'])
          ..sort((a, b) => a.producto.categoria.nombre
              .compareTo(b.producto.categoria.nombre));
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      if (e.runtimeType == SocketException)
        throw Exception(MessageException.noConnection);
      throw Exception(e.message);
    }
  }
}
