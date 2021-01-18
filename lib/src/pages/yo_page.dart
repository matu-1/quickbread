import 'package:flutter/material.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';

class YoPage extends StatelessWidget {
  final _prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: PageStorageKey('perfil'),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(75),
              child: Image(
                height: 150,
                width: 150,
                image: AssetImage('assets/images/default.jpg'),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('CI'),
              subtitle: Text(_prefs.usuario.ci),
              leading: Icon(
                Icons.assignment_ind,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Nombre'),
              subtitle: Text(_prefs.usuario.nombre),
              leading: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Apellido'),
              subtitle: Text(_prefs.usuario.apellido),
              leading: Icon(
                Icons.person_outline,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Teléfono celular'),
              subtitle: Text(_prefs.usuario.telefono),
              leading: Icon(
                Icons.phone_android,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Dirección'),
              subtitle: Text(_prefs.usuario.direccion),
              leading: Icon(
                Icons.directions,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(_prefs.usuario.email),
              leading: Icon(
                Icons.alternate_email,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Password'),
              subtitle: Text('******'),
              leading: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
