import 'package:quickbread/src/models/producto_model.dart';
import 'package:quickbread/src/models/sucursal_model.dart';

class SucursalProductoModel {
  int id;
  int stock;
  int stockMinimo;
  int stockMaximo;
  SucursalModel sucursal;
  ProductoModel producto;

  SucursalProductoModel({
    this.id,
    this.stock,
    this.stockMinimo,
    this.stockMaximo,
    this.sucursal,
    this.producto,
  });

  factory SucursalProductoModel.fromJson(Map json) => SucursalProductoModel(
        id: json['idsucursal_producto'],
        stock: json['stock'],
        stockMinimo: json['stock_minimo'],
        stockMaximo: json['stock_maximo'],
        producto: ProductoModel.fromJson(json['producto']),
        sucursal: SucursalModel.fromJson(json['sucursal']),
      );

  static List<SucursalProductoModel> fromJsonList(List jsonList) =>
      jsonList.map((e) => SucursalProductoModel.fromJson(e)).toList();
}
