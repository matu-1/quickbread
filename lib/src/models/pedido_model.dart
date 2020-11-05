import 'package:flutter/cupertino.dart';
import 'package:quickbread/src/models/cliente_model.dart';
import 'package:quickbread/src/models/sucursal_producto_model.dart';
import 'package:quickbread/src/models/ubicacion_model.dart';
import 'package:quickbread/src/utils/utils.dart';

List pedidosFromJsonList(List jsonList) =>
    List<PedidoModel>.from(jsonList.map((x) => PedidoModel.fromJson(x)));

class PedidoModel with ChangeNotifier {
  int id;
  String tiempoEntrega;
  String fecha;
  String hora;
  String coordenada;
  String direccion;
  String referencia;
  int tipoEntregId;
  String tipoEntrega;
  String observacion;
  String estado;
  double total;
  String fechaHora;
  int clienteId;
  int sucursalId;
  List<DetallePedidoModel> detalles;
  ClienteModel cliente;

  PedidoModel({
    this.id,
    this.tiempoEntrega,
    this.fecha,
    this.hora,
    this.coordenada,
    this.direccion,
    this.referencia,
    this.tipoEntregId,
    this.tipoEntrega,
    this.observacion,
    this.estado = 'en espera',
    this.total,
    this.fechaHora,
    this.clienteId,
    this.sucursalId,
    this.cliente,
    this.detalles,
  });

  factory PedidoModel.fromJson(Map json) => PedidoModel(
        id: json['idpedido'],
        tiempoEntrega: json['tiempo_entrega'],
        fecha: json['fecha'],
        hora: json['hora'],
        coordenada: json['coordenada'],
        direccion: json['direccion'],
        referencia: json['referencia'],
        observacion: json['observacion'],
        estado: json['estado'],
        total: double.parse(json['total']),
        tipoEntrega: json['tipo_entrega'],
        fechaHora: json['fecha_hora'],
        cliente: ClienteModel.fromJson(json['cliente']),
        detalles: List<DetallePedidoModel>.from(
            json['detalles'].map((x) => DetallePedidoModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fecha": fecha,
        "hora": hora,
        "coordenada": coordenada,
        "direccion": direccion,
        "referencia": referencia,
        "observacion": observacion,
        "estado": estado,
        "fkidtipo_entrega": tipoEntregId,
        "fecha_hora": fechaHora,
        "fkidcliente": clienteId,
        "fkidsucursal": detalles[0].sucursalProducto.sucursal.id,
        "total": total,
        "detalles": DetallePedidoModel.listToJson(detalles)
      };

  void add(DetallePedidoModel detalle) {
    detalles.add(detalle);
    notifyListeners();
  }

  void remove(DetallePedidoModel detalle) {
    detalles.remove(detalle);
    notifyListeners();
  }

  void setUbicacion(UbicacionModel ubicacion) {
    coordenada = ubicacion.coordenada;
    direccion = ubicacion.direccion;
    referencia = ubicacion.referencia;
    notifyListeners();
  }

  void setUbicacionSave(UbicacionModel ubicacion) {
    coordenada = ubicacion.coordenada;
    direccion = ubicacion.direccion;
    referencia = ubicacion.referencia;
  }

  bool existProducto(SucursalProductoModel producto) {
    final productoFinded =
        this.detalles.where((x) => x.sucursalProducto.id == producto.id);
    return productoFinded.length > 0;
  }

  String getFechaHora() {
    if (this.fecha == null) return 'Lo antes posible';
    return '${getFecha(DateTime.parse(this.fecha))}, ${this.hora.substring(0, 5)}';
  }

  String getFechaFormateada() {
    if (this.fecha == null) return 'Lo antes posible';
    return '${getFecha(DateTime.parse(this.fecha))}';
  }

  String getFechaHoraCorta() {
    return '${getDateShort(DateTime.parse(this.fecha))}, $hora';
  }

  String getHora() {
    return this.hora.substring(0, 5);
  }

  String getTotal() {
    return 'Bs.${this.total}';
  }

  String getCreatedAt() => this.fechaHora.substring(0, 16);

  void reset() {
    this.detalles.clear();
    notifyListeners();
  }

  void setFechaHora(String date, String time) {
    fecha = date;
    hora = time;
    notifyListeners();
  }
}

class DetallePedidoModel {
  int cantidad;
  double subtotal;
  SucursalProductoModel sucursalProducto;

  factory DetallePedidoModel.fromJson(Map json) => DetallePedidoModel(
        cantidad: json['cantidad'],
        sucursalProducto:
            SucursalProductoModel.fromJson(json['sucursal_producto']),
      );

  DetallePedidoModel({this.cantidad, this.sucursalProducto, this.subtotal});

  String getSubtotal() {
    return 'Bs.${this.cantidad * this.sucursalProducto.producto.precio}';
  }

  Map<String, dynamic> toJson() => {
        "idsucursal_producto": sucursalProducto.id,
        "cantidad": cantidad,
        "precio": sucursalProducto.producto.precio,
      };

  static List<Map<String, dynamic>> listToJson(
          List<DetallePedidoModel> detalles) =>
      detalles.map((x) => x.toJson()).toList();
}
