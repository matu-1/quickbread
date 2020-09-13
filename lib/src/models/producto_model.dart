import 'package:quickbread/src/constants/service.dart';
import 'package:quickbread/src/models/categoria_model.dart';

List<ProductoModel> productosFromJsonList(List jsonList) =>
    List<ProductoModel>.from(jsonList.map((x) => ProductoModel.fromJson(x)));

class ProductoModel {
  int id;
  String nombre;
  String descripcion;
  double precio;
  String foto;
  CategoriaModel categoria;

  ProductoModel(
      {this.id,
      this.nombre,
      this.descripcion,
      this.precio,
      this.foto,
      this.categoria});

  factory ProductoModel.fromJson(Map json) {
    return ProductoModel(
      id: json['idproducto'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: double.parse(json['precio']),
      foto: json['foto'],
      categoria: CategoriaModel.fromJson(json['categoria']),
    );
  }

  String getPrecio() => 'Bs.${this.precio}';

  String getPathImage() {
    return host.substring(0, host.length - 4) + '/$foto';
  }
}
