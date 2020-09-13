import 'package:flutter/material.dart';
import 'package:quickbread/src/pages/ayuda_page.dart';
import 'package:quickbread/src/pages/login_page.dart';
import 'package:quickbread/src/pages/pedido_nuevos_.page.dart';
import 'package:quickbread/src/pages/perfil_page.dart';
import 'package:quickbread/src/pages/producto_page.dart';
import 'package:quickbread/src/providers/push_notification_provider.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';
import 'package:quickbread/src/widgets/drawer_navigation.dart';

class HomePage extends StatefulWidget {
  static final routeName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextStyle styleText = TextStyle(fontSize: 20, height: 1.3);
  final _prefs = new PreferenciasUsuario();

  @override
  void initState() {
    final pushProvider = new PushNotificationProvider();
    pushProvider.initNotitication(onToken);
    pushProvider.messageStream.listen((message) {
      print(message);
      if (message['type'] == 'onMessage')
        showNotificationDialog(message['notification']);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuickBread'),
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
            if ((_prefs.usuario?.rol == 'cliente') || _prefs.usuario == null)
              _btnCrearPedido(context),
          ],
        ),
      ),
      drawer: DrawerNavigation(),
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

  void onToken(String token) {
    final prefs = new PreferenciasUsuario();
    prefs.token = token;
    print('token=' + token);
  }

  void showNotificationDialog(Map message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(message['title']),
              content: Text(message['body']),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('CERRAR'))
              ],
            ));
  }
}
