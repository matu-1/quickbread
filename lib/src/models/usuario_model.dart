// To parse this JSON data, do
//
//     final usuarioModel = usuarioModelFromJson(jsonString);

import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) => UsuarioModel.fromJson(json.decode(str));

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
    int estado;

    UsuarioModel({
        this.id,
        this.ci,
        this.nombre,
        this.apellido,
        this.telefono,
        this.direccion,
        this.email,
        this.password,
        this.estado,
    });

    factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        id: json["id"],
        ci: json['ci'],
        nombre: json["nombre"],
        apellido: json["apellido"],
        telefono: json["telefono"],
        direccion: json["direccion"],
        email: json["email"],
        password: json["password"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "telefono": telefono,
        "email": email,
        "password": password,
        "estado": estado,
    };
}