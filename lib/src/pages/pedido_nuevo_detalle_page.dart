import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickbread/src/constants/pages.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/mapa_page.dart';
import 'package:quickbread/src/widgets/boton_custom.dart';
import 'package:quickbread/src/widgets/text_prop.dart';

class PedidoNuevoDetallePage extends StatelessWidget {
  static final routeName = 'pedidoNuevoDetalle';
  final TextStyle styleTotal =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  final styleTitulo =
      TextStyle(fontSize: sizeTitulo, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    PedidoModel pedido = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(pedido.cliente.nombre),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _pedido(pedido),
            _divider(),
            _cliente(pedido),
            _divider(),
            _ubicacion(pedido, context),
            _divider(),
            _productoList(context, pedido),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () => _showConfirmDialog(context)),
    );
  }

  Widget _cliente(PedidoModel pedido) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cliente',
            style: styleTitulo,
          ),
          SizedBox(
            height: 5,
          ),
          TextProp(prop: 'Nombre:', text: pedido.cliente.getFullName()),
          TextProp(
              prop: 'Telefono celular:', text: pedido.cliente.telefonoCelular),
        ],
      ),
    );
  }

  Widget _ubicacion(PedidoModel pedido, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ubicacion',
            style: styleTitulo,
          ),
          SizedBox(
            height: 5,
          ),
          TextProp(prop: 'Calle y numero:', text: pedido.direccion),
          TextProp(prop: 'Referencia:', text: pedido.referencia),
          SizedBox(
            height: 10,
          ),
          BotonCustom(
            elevation: 0,
            outline: true,
            titulo: 'VER MAPA',
            onPressed: () => _verMapa(pedido, context),
          )
        ],
      ),
    );
  }

  Widget _pedido(PedidoModel pedido) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Podido',
            style: styleTitulo,
          ),
          SizedBox(
            height: 5,
          ),
          TextProp(prop: 'Fecha:', text: pedido.getFechaFormateada()),
          TextProp(prop: 'Hora:', text: pedido.getHora()),
          TextProp(prop: 'Tipo:', text: pedido.tipoEntrega),
          TextProp(prop: 'Total:', text: 'Bs.${pedido.total}'),
          TextProp(
              prop: 'Observacion:',
              text: pedido.observacion ?? 'No registrado'),
          TextProp(prop: 'Estado:', text: pedido.estado),
          TextProp(prop: 'Creado el:', text: pedido.fechaHora),
        ],
      ),
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

  void _verMapa(PedidoModel pedido, BuildContext context) {
    List<String> latLng = pedido.coordenada.split(',');
    LatLng coordenada = LatLng(num.parse(latLng[0]), num.parse(latLng[1]));
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => MapaPage(coordenada: coordenada)));
  }

  void _showConfirmDialog(BuildContext context) {
    final styleBtnText = TextStyle(color: Theme.of(context).primaryColor);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Marcar pedido'),
              content: Text('Esta seguro de marcarlo como entregado?'),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'CERRAR',
                      style: styleBtnText,
                    )),
                FlatButton(
                    onPressed: () {},
                    child: Text('GUARDAR', style: styleBtnText)),
              ],
            ));
  }
}
