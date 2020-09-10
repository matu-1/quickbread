import 'package:flutter/cupertino.dart';
import 'package:quickbread/src/models/cliente_model.dart';
import 'package:quickbread/src/models/producto_model.dart';
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
    this.estado,
    this.total,
    this.fechaHora,
    this.cliente,
    this.detalles,
  });

  factory PedidoModel.fromJson(Map json) => PedidoModel(
        id: json['id'],
        tiempoEntrega: json['tiempo_entrega'],
        fecha: json['fecha'],
        hora: json['hora'],
        coordenada: json['coordenada'],
        direccion: json['direccion'],
        referencia: json['referencia'],
        observacion: json['observacion'],
        estado: json['estado'],
        total: json['total'],
        tipoEntrega: json['tipo_entrega'],
        fechaHora: json['fecha_hora'],
        cliente: ClienteModel.fromJson(json['cliente']),
        detalles: List<DetallePedidoModel>.from(
            json['detalles'].map((x) => DetallePedidoModel.fromJson(x))),
      );

  void add(DetallePedidoModel detalle) {
    detalles.add(detalle);
    notifyListeners();
  }

  void remove(DetallePedidoModel detalle) {
    detalles.remove(detalle);
    notifyListeners();
  }

  bool existProducto(ProductoModel producto) {
    final productoFinded = this.detalles.where((x) => x.producto.id == producto.id);
    print(productoFinded.length);
    return productoFinded.length > 0;
  }

  String getFechaHora() {
    return '${getFecha(DateTime.parse(this.fecha))} a las ${this.hora.substring(0, 5)}';
  }

  String getFechaFormateada() {
    return '${getFecha(DateTime.parse(this.fecha))}';
  }

  String getHora() {
    return this.hora.substring(0, 5);
  }

  String getTotal() {
    return 'Bs.${this.total}';
  }
}

class DetallePedidoModel {
  int cantidad;
  double subtotal;
  ProductoModel producto;

  factory DetallePedidoModel.fromJson(Map json) => DetallePedidoModel(
        cantidad: json['cantidad'],
        producto: ProductoModel.fromJson(json['producto']),
      );

  DetallePedidoModel({this.cantidad, this.producto, this.subtotal});

  String getSubtotal() {
    return 'Bs.${this.cantidad * this.producto.precio}';
  }
}
