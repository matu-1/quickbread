import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quickbread/src/constants/service.dart';
import 'package:quickbread/src/models/producto_model.dart';

class ProductoProvider {
  Future<List<ProductoModel>> getAll() async {
    try {
      final response = await http.get(api['producto']['listar']);
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return productosFromJsonList(data['data']);
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      throw Exception('Ups no hay conexion');
    }
  }
}
