import 'package:flutter/material.dart';
import 'package:quickbread/src/icons/my_icon_icons.dart';
import 'package:quickbread/src/pages/about_page.dart';
import 'package:quickbread/src/pages/ayuda_page.dart';
import 'package:quickbread/src/pages/login_page.dart';
import 'package:quickbread/src/pages/pedido_nuevos_.page.dart';
import 'package:quickbread/src/pages/perfil_page.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';

class DrawerNavigation extends StatelessWidget {
  final _prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: GestureDetector(
              onTap: _prefs.usuario != null
                  ? null
                  : () => Navigator.of(context).pushNamed(LoginPage.routeName),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircleAvatar(
                        radius: 35,
                        backgroundColor: Theme.of(context).accentColor,
                        child: _prefs.usuario != null
                            ? Text(
                                _prefs.usuario.getInitialName(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                MyIcon.carritatriste,
                                size: 50,
                                color: Colors.white,
                              )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _prefs.usuario != null
                          ? _prefs.usuario.getFullName()
                          : 'Ingresa o Registrate',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    if (_prefs.usuario != null &&
                        _prefs.usuario.rol != 'cliente')
                      Text(
                        _prefs.usuario.rol,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          ListTile(
              leading: Icon(
                Icons.home,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Inicio'),
              onTap: () => Navigator.pop(context)),
          if (_prefs.usuario != null) ...logeado(context),
          ListTile(
            leading: Icon(
              Icons.help,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Ayuda'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AyudaPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Acerca de'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AboutPage.routeName);
            },
          ),
          if (_prefs.usuario != null)
            ListTile(
              leading: Icon(
                Icons.highlight_off,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Cerrar sesion'),
              onTap: () => _prefs.logout(context),
            ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  List<Widget> logeado(BuildContext context) {
    return [
      ListTile(
        leading: Icon(
          Icons.person,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('Perfil'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, PerfilPage.routeName);
        },
      ),
      if (_prefs.usuario.rol != 'cliente') ...logeadoAdmin(context),
    ];
  }

  List<Widget> logeadoAdmin(BuildContext context) {
    return [
      Divider(),
      ListTile(
        leading: Icon(
          Icons.shopping_basket,
          color: Theme.of(context).primaryColor,
        ),
        title: Text('Pedido'),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, PedidoNuevoPage.routeName);
        },
      ),
      Divider(),
    ];
  }
}
