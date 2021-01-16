import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/path.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/login_page.dart';
import 'package:quickbread/src/pages/pedido_create_page.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';
import 'package:quickbread/src/widgets/error_custom.dart';

class PedidoResumenPage extends StatefulWidget {
  static final routeName = 'pedidoResumen';

  @override
  _PedidoResumenPageState createState() => _PedidoResumenPageState();
}

class _PedidoResumenPageState extends State<PedidoResumenPage> {
  final TextStyle styleTotal =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  bool _isDelete = false;
  final _prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos agregados'),
        actions: [
          IconButton(
              icon: Icon(!_isDelete ? Icons.delete : Icons.close),
              onPressed: () => setState(() => _isDelete = !_isDelete))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: _productoList(context)),
            _botones(context)
          ],
        ),
      ),
    );
  }

  Widget _productoList(BuildContext context) {
    final detalles = Provider.of<PedidoModel>(context).detalles;
    if (detalles.length == 0)
      return ErrorCustom(message: 'No tienes productos');

    return ListView(
      children: [
        ...detalles.map((detalle) => _productoBox(detalle, context)),
        Padding(
          padding: EdgeInsets.all(paddingUI),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: styleTotal,
              ),
              Text(
                'Bs.${getTotal(context)}',
                style: styleTotal,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _productoBox(DetallePedidoModel detallePedido, BuildContext context) {
    final styleTitulo =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.4);
    final styleTexto = TextStyle(height: 1.4, color: Colors.grey[600]);
    final stylePrecio = TextStyle(height: 1.4);

    return Container(
        padding: EdgeInsets.all(paddingUI),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: FadeInImage(
                placeholder: AssetImage(pathLoading),
                image: NetworkImage(
                    detallePedido.sucursalProducto.producto.getPathImage()),
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detallePedido.sucursalProducto.producto.nombre,
                    style: styleTitulo,
                  ),
                  Text(
                    detallePedido.sucursalProducto.producto.descripcion,
                    style: styleTexto,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${detallePedido.sucursalProducto.producto.getPrecio()} x ${detallePedido.cantidad}',
                    style: stylePrecio,
                  ),
                ],
              ),
            ),
            if (_isDelete)
              IconButton(
                  color: Theme.of(context).accentColor,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    final pedido =
                        Provider.of<PedidoModel>(context, listen: false);
                    pedido.remove(detallePedido);
                  }),
            if (!_isDelete)
              Text(
                'Bs.${detallePedido.subtotal}',
                style: stylePrecio,
              ),
          ],
        ));
  }

  Widget _botones(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
              child: RaisedButton(
            elevation: 1,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                    width: 1, color: Theme.of(context).primaryColor)),
            color: Colors.white,
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              final isByIcon = ModalRoute.of(context).settings.arguments;
              int count = isByIcon != null ? 1 : 0;
              print('count $count');
              Navigator.of(context).popUntil((route) {
                return count++ == 2;
              });
            },
            child: Text('SEGUIR AGREGANDO'),
          )),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: RaisedButton(
            elevation: 1,
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 15),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onPressed: !hasDetalles(context) ? null : _siguiente,
            child: Text('SIGUIENTE'),
            disabledColor: Theme.of(context).primaryColor.withOpacity(0.4),
            disabledTextColor: Colors.white,
          )),
        ],
      ),
    );
  }

  double getTotal(BuildContext context) {
    final pedido = Provider.of<PedidoModel>(context);
    double total = 0;
    pedido.detalles.forEach((x) => total += x.subtotal);
    pedido.total = total;
    return total;
  }

  bool hasDetalles(BuildContext context) {
    final detalles = Provider.of<PedidoModel>(context).detalles;
    return detalles.length > 0;
  }

  void _siguiente() {
    if (_prefs.usuario == null) {
      Navigator.of(context).pushNamed(LoginPage.routeName, arguments: true);
      return;
    }
    Navigator.of(context).pushNamed(PedidoCreatePage.routeName);
  }
}
