import 'package:flutter/material.dart';
import 'package:quickbread/src/pages/pedido_page.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: currentIndex == 0 ? Icon(Icons.edit) : Icon(Icons.refresh),
      ),
    );
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
