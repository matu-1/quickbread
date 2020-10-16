import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class UbicacionModel {
  String coordenada;
  String direccion;
  String referencia;

  UbicacionModel({this.direccion, this.coordenada, this.referencia});

  factory UbicacionModel.fromJson(Map json) => UbicacionModel(
      coordenada: json['coordenada'],
      direccion: json['direccion'],
      referencia: json['referencia']);

  Map<String, dynamic> toJson() => {
        'coordenada': this.coordenada,
        'direccion': this.direccion,
        'referencia': this.referencia,
      };

  static UbicacionModel ubicacionFromJson(String jsonStr) =>
      UbicacionModel.fromJson(json.decode(jsonStr));

  static String ubicacionToJson(UbicacionModel ubicacion) =>
      json.encode(ubicacion.toJson());

  LatLng getLatLng() {
    final values = this.coordenada.split(',');
    return new LatLng(double.parse(values[0]), double.parse(values[1]));
  }
}
