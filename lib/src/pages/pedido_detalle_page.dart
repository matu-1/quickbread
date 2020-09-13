import 'package:flutter/material.dart';
import 'package:quickbread/src/constants/pages.dart';
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _contenido(pedido),
          _divider(),
          _productoList(context, pedido)
        ],
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.delete), onPressed: () {}),
    );
  }

  Padding _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Divider(
        height: 1,
        color: Colors.grey[350],
      ),
    );
  }

  Widget _contenido(PedidoModel pedido) {
    return Container(
      padding: EdgeInsets.all(padding),
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
          TextProp(prop: 'Fecha:', text: pedido.getFechaFormateada()),
          TextProp(prop: 'Hora:', text: pedido.getHora()),
          TextProp(prop: 'Tipo:', text: pedido.tipoEntrega),
          TextProp(prop: 'Total:', text: 'Bs.${pedido.total}'),
          TextProp(prop: 'Observacion:', text: pedido.observacion ?? 'No registrado'),
          TextProp(prop: 'Estado:', text: pedido.estado),
          TextProp(prop: 'Creado el:', text: pedido.fechaHora),
        ],
      ),
    );
  }

  Widget _productoList(BuildContext context, PedidoModel pedido) {
    final detalles = pedido.detalles;

    return Padding(
      padding: EdgeInsets.all(padding),
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
        padding: EdgeInsets.symmetric(vertical: padding),
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
                image: NetworkImage(detallePedido.producto.getPathImage()),
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
            Text(
              detallePedido.getSubtotal(),
              style: stylePrecio,
            ),
          ],
        ));
  }
}
