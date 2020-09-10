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

  factory ProductoModel.fromJson(Map json) => ProductoModel(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
        precio: json['precio'],
        foto: json['foto'],
        categoria: CategoriaModel.fromJson(json['categoria']),
      );

  String getPrecio() => 'Bs.${this.precio}';
}
