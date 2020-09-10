import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/pages.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/pedido_ubicacion.dart';

class PedidoResumenPage extends StatefulWidget {
  static final routeName = 'pedidoResumen';

  @override
  _PedidoResumenPageState createState() => _PedidoResumenPageState();
}

class _PedidoResumenPageState extends State<PedidoResumenPage> {
  final TextStyle styleTotal =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  bool _isDelete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panes agregados'),
        actions: [
          IconButton(
              icon: Icon(!_isDelete?Icons.delete: Icons.close),
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

    return ListView(
      children: [
        ...detalles.map((detalle) => _productoBox(detalle, context)),
        Padding(
          padding: EdgeInsets.all(padding),
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
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3);
    final styleTexto = TextStyle(height: 1.3, color: Colors.grey[600]);
    final stylePrecio = TextStyle(height: 1.3);

    return Container(
        padding: EdgeInsets.all(padding),
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
                image: NetworkImage(detallePedido.producto.foto),
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
                    detallePedido.producto.nombre,
                    style: styleTitulo,
                  ),
                  Text(
                    detallePedido.producto.descripcion,
                    style: styleTexto,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${detallePedido.producto.getPrecio()} x ${detallePedido.cantidad}',
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
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 15),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onPressed: !hasDetalles(context)
                ? null
                : () =>
                    Navigator.of(context).pushNamed(PedidoUbicacion.routeName),
            child: Text('SIGUIENTE'),
          )),
        ],
      ),
    );
  }

  double getTotal(BuildContext context) {
    final detalles = Provider.of<PedidoModel>(context).detalles;
    double total = 0;
    detalles.forEach((x) => total += x.subtotal);
    return total;
  }

  bool hasDetalles(BuildContext context) {
    final detalles = Provider.of<PedidoModel>(context).detalles;
    return detalles.length > 0;
  }
}
