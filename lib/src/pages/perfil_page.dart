import 'package:flutter/material.dart';
import 'package:quickbread/src/blocs/pedido_bloc.dart';
import 'package:quickbread/src/pages/pedido_page.dart';
import 'package:quickbread/src/pages/yo_edit_page.dart';
import 'package:quickbread/src/pages/yo_page.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';

class PerfilPage extends StatefulWidget {
  static final routeName = 'perfil';
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  int currentIndex = 0;
  final _prefs = new PreferenciasUsuario();
  final _pedidoBloc = new PedidoBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Perfil'),
        ),
        body: _cargarPagina(),
        bottomNavigationBar: _prefs.usuario.rol != 'cliente'
            ? null
            : _contenedorBottonNavigationBar(),
        floatingActionButton: _floatingActionButton());
  }

  Widget _floatingActionButton() {
    if (currentIndex == 0) {
      return FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(YoEditPage.routeName),
        child: Icon(Icons.edit),
      );
    } else {
      return FloatingActionButton(
        onPressed: _pedidoBloc.getByCliente,
        child: Icon(Icons.refresh),
      );
    }
  }

  Widget _contenedorBottonNavigationBar() {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.sentiment_satisfied), label: 'Yo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Pedidos'),
        ]);
  }

  Widget _cargarPagina() {
    switch (currentIndex) {
      case 0:
        return YoPage();
      case 1:
        return PedidoPage();
      default:
        return YoPage();
    }
  }
}
