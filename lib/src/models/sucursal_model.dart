import 'package:quickbread/src/constants/service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SucursalModel {
  int id;
  String nombre;
  String direccion;
  String telefono;
  String foto;
  String horariosAtencion;
  String coordenada;

  SucursalModel({
    this.id,
    this.nombre,
    this.direccion,
    this.telefono,
    this.foto,
    this.horariosAtencion,
    this.coordenada,
  });

  factory SucursalModel.fromJson(Map json) => SucursalModel(
      id: json['idsucursal'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      foto: json['foto'],
      horariosAtencion: json['horarios_atencion'],
      coordenada: json['coordenada']);

  String getInitial() => this.nombre.substring(0, 1).toUpperCase();

  String getPathImage() {
    return host.substring(0, host.length - 4) + '/$foto';
  }

  LatLng getCoordenada() {
    List<String> latLng = coordenada.split(',');
    return LatLng(num.parse(latLng[0]), num.parse(latLng[1]));
  }

  List<HorarioAtencion> getHorariosAtencion() {
    final datos = this.horariosAtencion.split('|');
    return datos.map((e) => HorarioAtencion.fromString(e)).toList();
  }

  bool isAvailable() {
    final hoy = new DateTime.now();
    for (var item in this.getHorariosAtencion()) {
      final horaInicio = new DateTime(hoy.year, hoy.month, hoy.day,
          item.initialHour, item.initialMinute, 0);
      final horaFin = new DateTime(
          hoy.year, hoy.month, hoy.day, item.endHour, item.endMinute, 0);
      if (num.parse(item.dia) == hoy.weekday &&
          hoy.compareTo(horaInicio) >= 0 &&
          hoy.compareTo(horaFin) <= 0) return true;
    }
    return false;
  }

  static List<SucursalModel> fromJsonList(List jsonList) =>
      jsonList.map((e) => SucursalModel.fromJson(e)).toList();
}

class HorarioAtencion {
  String dia;
  String horaInicio;
  String horaFin;

  HorarioAtencion({this.dia, this.horaInicio, this.horaFin});

  factory HorarioAtencion.fromString(String data) {
    final diahorarios = data.split(',');
    final horarios = diahorarios[1].split('-');
    return HorarioAtencion(
        dia: diahorarios[0], horaInicio: horarios[0], horaFin: horarios[1]);
  }

  int get initialHour {
    return num.parse(horaInicio.split(':')[0]);
  }

  int get initialMinute {
    return num.parse(horaInicio.split(':')[1]);
  }

  int get endHour {
    return num.parse(horaFin.split(':')[0]);
  }

  int get endMinute {
    return num.parse(horaFin.split(':')[1]);
  }
}
