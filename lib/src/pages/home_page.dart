import 'package:flutter/material.dart';
import 'package:quickbread/src/pages/ayuda_page.dart';
import 'package:quickbread/src/pages/login_page.dart';
import 'package:quickbread/src/pages/pedido_nuevos_.page.dart';
import 'package:quickbread/src/pages/perfil_page.dart';
import 'package:quickbread/src/pages/producto_page.dart';

class HomePage extends StatelessWidget {
  static final routeName = 'home';
  final TextStyle styleText =
      TextStyle(fontSize: 20, height: 1.3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuickBread'),
        actions: [
          PopupMenuButton(
              onSelected: (value) => _selectedPopuMenu(value, context),
              itemBuilder: (_) {
                return [
                  PopupMenuItem(
                    child: Text('Iniciar sesion'),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text('Perfil'),
                    value: 2,
                  ),
                  PopupMenuItem(
                    child: Text('Ayuda'),
                    value: 3,
                  ),
                  PopupMenuItem(
                    child: Text('Repartidor'),
                    value: 4,
                  ),
                ];
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            Text(
              'Bienvenido a nuestra aplicacion de pedidos, empieza creando uno.',
              style: styleText,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
            _btnCrearPedido(context),
          ],
        ),
      ),
    );
  }

  Widget _btnCrearPedido(BuildContext context) {
    return RaisedButton(
      onPressed: () => Navigator.of(context).pushNamed(ProductoPage.routeName),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      shape: StadiumBorder(),
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Text('CREAR PEDIDO'),
      ),
    );
  }

  void _selectedPopuMenu(value, BuildContext context) {
    switch (value) {
      case 1:
        Navigator.of(context).pushNamed(LoginPage.routeName);
        break;
      case 2:
        Navigator.of(context).pushNamed(PerfilPage.routeName);
        break;
      case 3:
        Navigator.of(context).pushNamed(AyudaPage.routeName);
        break;
      case 4:
        Navigator.of(context).pushNamed(PedidoNuevoPage.routeName);
        break;
      default:
    }
  }
}
