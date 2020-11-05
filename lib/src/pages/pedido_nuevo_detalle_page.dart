import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickbread/src/constants/path.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/pages/mapa_page.dart';
import 'package:quickbread/src/pages/pedido_nuevos_.page.dart';
import 'package:quickbread/src/providers/pedido_provider.dart';
import 'package:quickbread/src/widgets/boton_custom.dart';
import 'package:quickbread/src/widgets/text_prop.dart';
import 'package:quickbread/src/utils/utils.dart' as utils;

class PedidoNuevoDetallePage extends StatelessWidget {
  static final routeName = 'pedidoNuevoDetalle';
  final TextStyle styleTotal =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  final styleTitulo =
      TextStyle(fontSize: sizeTituloUI, fontWeight: FontWeight.w600);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    PedidoModel pedido = ModalRoute.of(context).settings.arguments;
    final pr = new ProgressDialog(context, isDismissible: false);
    pr.style(message: 'Espere por favor');

    return Scaffold(
      key: _scaffoldKey,
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
          onPressed: () => _showConfirmDialog(context, pr, pedido)),
    );
  }

  Widget _cliente(PedidoModel pedido) {
    return Container(
      padding: EdgeInsets.all(paddingUI),
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
      padding: EdgeInsets.all(paddingUI),
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
      padding: EdgeInsets.all(paddingUI),
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
          TextProp(prop: 'Cuando:', text: pedido.getFechaHora()),
          TextProp(prop: 'Tipo entrega:', text: pedido.tipoEntrega),
          TextProp(prop: 'Total:', text: 'Bs.${pedido.total}'),
          TextProp(
              prop: 'Observacion:',
              text: pedido.observacion ?? 'No registrado'),
          TextProp(prop: 'Estado:', text: pedido.estado),
          TextProp(prop: 'Creado el:', text: pedido.getCreatedAt()),
        ],
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
            Text(
              detallePedido.getSubtotal(),
              style: stylePrecio,
            ),
          ],
        ));
  }

  void _verMapa(PedidoModel pedido, BuildContext context) {
    LatLng coordenada = pedido.getCoordenada();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            MapaPage(coordenada: coordenada, titulo: pedido.direccion)));
  }

  void _showConfirmDialog(
      BuildContext context, ProgressDialog pr, PedidoModel pedido) {
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
                    onPressed: () => setEntregado(pr, pedido, context),
                    child: Text('GUARDAR', style: styleBtnText)),
              ],
            ));
  }

  void setEntregado(
      ProgressDialog pr, PedidoModel pedido, BuildContext context) async {
    final pedidoProvider = new PedidoProvider();
    Navigator.of(context).pop();
    pr.show();
    try {
      await pedidoProvider.setEntregado(pedido.id);
      pr.hide();
      Navigator.of(_scaffoldKey.currentContext).pushNamedAndRemoveUntil(
          PedidoNuevoPage.routeName, ModalRoute.withName(HomePage.routeName));
    } catch (e) {
      utils.showSnackbar(e.message, _scaffoldKey);
      Future.delayed(Duration(milliseconds: 200), () => pr.hide());
    }
  }
}
