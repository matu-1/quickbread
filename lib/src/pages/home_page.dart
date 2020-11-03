import 'package:flutter/material.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/sucursal_model.dart';
import 'package:quickbread/src/pages/pedido_ubicacion.dart';
import 'package:quickbread/src/pages/producto_page.dart';
import 'package:quickbread/src/providers/push_notification_provider.dart';
import 'package:quickbread/src/providers/sucursal_provider.dart';
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
  final SucursalProvider _sucursalProvider = new SucursalProvider();

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
        title: GestureDetector(
          onTap: () =>
              Navigator.of(context).pushNamed(PedidoUbicacion.routeName),
          child: Row(
            children: [
              Text(
                _prefs.ubicacion.direccion,
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).primaryColor),
              ),
              Icon(Icons.keyboard_arrow_down)
            ],
          ),
        ),
      ),
      body: _sucursalList(),
      drawer: DrawerNavigation(),
    );
  }

  Container _bodyContainer(BuildContext context) {
    return Container(
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

  Widget _sucursalList() {
    // List<SucursalModel> sucursales = SucursalModel.fromJsonList(sucursalData);
    return FutureBuilder(
      future: _sucursalProvider.getAll(),
      builder:
          (BuildContext context, AsyncSnapshot<List<SucursalModel>> snapshot) {
        if (snapshot.hasData) {
          final sucursales = snapshot.data;

          return ListView.builder(
            itemCount: sucursales.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      ProductoPage.routeName,
                      arguments: sucursales[index]),
                  child: _sucursalBox(sucursales[index]));
            },
          );
        }
        if (snapshot.hasError) {
          final dynamic error = snapshot.error;
          return Center(
            child: Text(error.message),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _sucursalBox(SucursalModel sucursal) {
    return Container(
      padding: EdgeInsets.all(paddingUI),
      margin: EdgeInsets.only(top: 15, left: paddingUI, right: paddingUI),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 3)],
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          CircleAvatar(
            child: Text(sucursal.getInitial()),
            backgroundColor: Theme.of(context).accentColor,
            radius: 25,
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sucursal.nombre,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(sucursal.direccion),
              ],
            ),
          )
        ],
      ),
    );
  }
}
