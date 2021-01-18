import 'package:flutter/material.dart';
import 'package:quickbread/src/constants/common_text.dart';
import 'package:quickbread/src/constants/path.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/widgets/text_prop.dart';

class PedidoDetallePage extends StatelessWidget {
  static final routeName = 'pedidoDetalle';
  final TextStyle styleTotal =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  final styleTitulo = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    PedidoModel pedido = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi pedido'),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => showAnularDialog(context))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _pedido(pedido),
            _divider(),
            _sucursal(pedido),
            _divider(),
            _productoList(context, pedido)
          ],
        ),
      ),
    );
  }

  Padding _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingUI),
      child: Divider(
        height: 1,
        color: Colors.grey[350],
      ),
    );
  }

  Widget _sucursal(PedidoModel pedido) {
    return Container(
      padding: EdgeInsets.all(paddingUI),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sucursal',
            style: styleTitulo,
          ),
          SizedBox(
            height: 5,
          ),
          TextProp(
              prop: 'Nombre:',
              text: pedido.detalles[0].sucursalProducto.sucursal.nombre),
          TextProp(
              prop: 'Dirección:',
              text: pedido.detalles[0].sucursalProducto.sucursal.direccion),
        ],
      ),
    );
  }

  Widget _pedido(PedidoModel pedido) {
    return Container(
      padding: EdgeInsets.all(paddingUI),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pedido',
            style: styleTitulo,
          ),
          SizedBox(
            height: 5,
          ),
          TextProp(prop: 'Cuando:', text: pedido.getFechaHora()),
          TextProp(prop: 'Tipo:', text: pedido.tipoEntrega),
          TextProp(prop: 'Total:', text: 'Bs.${pedido.total}'),
          TextProp(
              prop: 'Observación:',
              text: pedido.observacion ?? 'No registrado'),
          TextProp(prop: 'Estado:', text: pedido.estado),
          TextProp(prop: 'Creado el:', text: pedido.getCreatedAt()),
        ],
      ),
    );
  }

  Widget _productoList(BuildContext context, PedidoModel pedido) {
    final detalles = pedido.detalles;

    return Padding(
      padding: EdgeInsets.all(paddingUI),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Productos',
            style: styleTitulo,
          ),
          ...detalles.map((detalle) => _productoBox(detalle, context)),
        ],
      ),
    );
  }

  Widget _productoBox(DetallePedidoModel detallePedido, BuildContext context) {
    final styleTitulo =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3);
    final styleTexto = TextStyle(height: 1.3, color: Colors.grey[600]);
    final stylePrecio = TextStyle(height: 1.3);

    return Container(
        padding: EdgeInsets.symmetric(vertical: paddingUI),
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
                  Text(
                    '${detallePedido.sucursalProducto.producto.getPrecio()} x ${detallePedido.cantidad}',
                    style: stylePrecio,
                  ),
                ],
              ),
            ),
            Text(
              detallePedido.getSubtotal(),
              style: stylePrecio,
            ),
          ],
        ));
  }

  void showAnularDialog(BuildContext context) {
    final styleBtnText = TextStyle(color: Theme.of(context).primaryColor);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Anular pedido'),
            content: Text('Esta seguro de anularlo?'),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    CommonText.close,
                    style: styleBtnText,
                  )),
              FlatButton(
                  onPressed: () {},
                  child: Text(CommonText.save, style: styleBtnText)),
            ],
          );
        });
  }
}
