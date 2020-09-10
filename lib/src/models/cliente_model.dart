List<ClienteModel> clientesFromJsonList(List jsonList) =>
    List<ClienteModel>.from(jsonList.map((x) => ClienteModel.fromJson(x)));

class ClienteModel {
  int id;
  String nombre;
  String apellido;
  String telefonoCelular;
  String direccion;

  ClienteModel({
    this.id,
    this.nombre,
    this.apellido,
    this.telefonoCelular,
    this.direccion,
  });

  factory ClienteModel.fromJson(Map json) => ClienteModel(
        id: json['id'],
        nombre: json['nombre'],
        apellido: json['apellido'],
        telefonoCelular: json['telefono_celular'],
        direccion: json['foto'],
      );

  String getFullName() => '${this.nombre} ${this.apellido}';

  String getInitialName() {
    return this.nombre[0].toUpperCase();
  }
}
