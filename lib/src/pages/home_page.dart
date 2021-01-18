import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/path.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/models/sucursal_model.dart';
import 'package:quickbread/src/pages/pedido_ubicacion.dart';
import 'package:quickbread/src/pages/producto_page.dart';
import 'package:quickbread/src/providers/push_notification_provider.dart';
import 'package:quickbread/src/providers/sucursal_provider.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';
import 'package:quickbread/src/widgets/drawer_navigation.dart';
import 'package:quickbread/src/widgets/error_custom.dart';

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
    Provider.of<PedidoModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(PedidoUbicacion.routeName, arguments: true),
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
    final width = MediaQuery.of(context).size.width;
    final height = 200.0;
    return Container(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height,
              width: double.infinity,
              child: CustomPaint(
                painter: _HeaderPainter(color: Theme.of(context).primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.translate(
                      offset: Offset(width * 0.25 - 40, height * 0.23),
                      child: Icon(
                        Icons.moped,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(-width * 0.25 + 45, -height * 0.09),
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 90,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Bienvenido a la aplicación de pedido',
                    style: TextStyle(
                        fontSize: 24,
                        height: 1.4,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Esta sección se encarga de la entrega de los pedidos, por favor dale una mirada a tus pedidos asignados, gracias.',
                    style: TextStyle(color: Colors.grey[600], height: 1.4),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sucursalList() {
    if (_prefs.usuario != null && _prefs.usuario.rol != 'cliente')
      return _bodyContainer(context);
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
                  onTap: () => goProductPage(sucursales[index]),
                  child: _sucursalBox(sucursales[index]));
            },
          );
        } else if (snapshot.hasError) {
          final dynamic error = snapshot.error;
          return ErrorCustom(message: error.message);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _sucursalBox(SucursalModel sucursal) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingUI),
      margin: EdgeInsets.symmetric(horizontal: paddingUI),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FadeInImage(
              placeholder: AssetImage(pathLoading),
              image: NetworkImage(sucursal.getPathImage()),
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
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
                if (!sucursal.isAvailable())
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Cerrado',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).errorColor),
                    ),
                  ),
              ],
            ),
          )
        ],
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
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('CERRAR'))
              ],
            ));
  }

  void goProductPage(SucursalModel sucursal) {
    if (sucursal.isAvailable())
      Navigator.of(context).pushNamed(
        ProductoPage.routeName,
        arguments: sucursal,
      );
    else
      showCerradoDialog(sucursal);
  }

  void showCerradoDialog(SucursalModel sucursal) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Cerrado'),
              content:
                  Text('La sucursal esta cerrada, solo puedes ver el catálogo'),
              actions: [
                FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('CERRAR')),
                FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(
                        ProductoPage.routeName,
                        arguments: sucursal,
                      );
                    },
                    child: Text('CONTINUAR'))
              ],
            ));
  }
}

class _HeaderPainter extends CustomPainter {
  Color color;

  _HeaderPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint(); // lapiz
    paint.color = color;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 3;

    final path = new Path(); // los trazos
    path.lineTo(0, size.height * 0.70);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height * 0.70);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.4, size.width, size.height * 0.70);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
