class SucursalModel {
  int id;
  String nombre;
  String direccion;
  String telefono;

  SucursalModel({
    this.id,
    this.nombre,
    this.direccion,
    this.telefono,
  });

  factory SucursalModel.fromJson(Map json) => SucursalModel(
        id: json['idsucursal'],
        nombre: json['nombre'],
        direccion: json['direccion'],
        telefono: json['telefono'],
      );

  String getInitial() => this.nombre.substring(0, 1).toUpperCase();

  static List<SucursalModel> fromJsonList(List jsonList) =>
      jsonList.map((e) => SucursalModel.fromJson(e)).toList();
}
