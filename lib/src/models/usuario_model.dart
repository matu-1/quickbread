// To parse this JSON data, do
//
//     final usuarioModel = usuarioModelFromJson(jsonString);

import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  int id;
  String ci;
  String nombre;
  String apellido;
  String telefono;
  String direccion;
  String email;
  String password;
  String rol;
  String token;
  int sucursalId;

  UsuarioModel({
    this.id,
    this.ci,
    this.nombre,
    this.apellido,
    this.telefono,
    this.direccion,
    this.email,
    this.password,
    this.rol = 'cliente',
    this.token,
    this.sucursalId,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
      id: json["id"],
      ci: json['ci'],
      nombre: json["nombre"],
      apellido: json["apellido"],
      telefono: json["telefono_celular"],
      direccion: json["direccion"],
      email: json["email"],
      password: json["password"],
      rol: json["rol"],
      sucursalId: json['fkidsucursal']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "ci": ci,
        "nombre": nombre,
        "apellido": apellido,
        "telefono_celular": telefono,
        "direccion": direccion,
        "email": email,
        "password": password,
        "rol": rol,
        'token': token,
        'fkidsucursal': sucursalId,
      };

  Map<String, dynamic> toJsonUpdate() => {
        "nombre": nombre,
        "apellido": apellido,
        "telefono": telefono,
        "rol" : rol,
      };

  setUpdate(UsuarioModel usuario) {
    this.nombre = usuario.nombre;
    this.apellido = usuario.apellido;
    this.telefono = usuario.telefono;
  }

  String getFullName() => '${this.nombre} $apellido';

  String getInitialName() => this.nombre[0].toUpperCase();
}
