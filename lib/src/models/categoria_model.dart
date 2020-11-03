class CategoriaModel {
  int id;
  String nombre;

  CategoriaModel({this.id, this.nombre});

  factory CategoriaModel.fromJson(Map json) => CategoriaModel(
    id: json['idcategoria'],
    nombre: json['nombre'],
  );
}
