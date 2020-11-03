import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:quickbread/src/constants/message_exception.dart';
import 'package:quickbread/src/constants/service.dart';
import 'package:quickbread/src/models/sucursal_model.dart';

class SucursalProvider {
  Future<List<SucursalModel>> getAll() async {
    try {
      final response = await http.get(Api.sucursalListar);
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return SucursalModel.fromJsonList(data['data']);
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
