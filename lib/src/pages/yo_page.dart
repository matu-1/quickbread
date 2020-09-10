import 'package:flutter/material.dart';

class YoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              subtitle: Text('12457854'),
              leading: Icon(
                Icons.assignment_ind,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Nombre'),
              subtitle: Text('matias'),
              leading: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Apellido'),
              subtitle: Text('flores'),
              leading: Icon(
                Icons.person_outline,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Telefono'),
              subtitle: Text('75456458'),
              leading: Icon(
                Icons.phone_android,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Direccion'),
              subtitle: Text('plan 3000'),
              leading: Icon(
                Icons.directions,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text('matu@gmail.com'),
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
