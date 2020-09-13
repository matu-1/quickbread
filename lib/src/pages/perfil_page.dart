import 'package:flutter/material.dart';
import 'package:quickbread/src/pages/pedido_page.dart';
import 'package:quickbread/src/pages/yo_page.dart';

class PerfilPage extends StatefulWidget {
  static final routeName = 'perfil';
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: _cargarPagina(),
      bottomNavigationBar: _contenedorBottonNavigationBar(),
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
              icon: Icon(Icons.sentiment_satisfied), title: Text('Yo')),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: Text('Pedidos')),
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
