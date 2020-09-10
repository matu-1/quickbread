import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:quickbread/src/constants/pages.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/mapa_page.dart';
import 'package:quickbread/src/widgets/boton_custom.dart';

class PedidoNuevoDetallePage extends StatelessWidget {
  static final routeName = 'pedidoNuevoDetalle';
  final TextStyle styleTotal =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  final styleTitulo = TextStyle(fontSize: sizeTitulo, fontWeight: FontWeight.w600);

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
            _contenido(pedido),
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
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.edit), onPressed: () {}),
    );
  }

  Widget _cliente(PedidoModel pedido) {
    final styleSubtitulo = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: Colors.black);
    final styleTexto =
        TextStyle(height: 1.5, fontSize: 14, fontWeight: FontWeight.normal);

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
          RichText(
            text: TextSpan(text: 'Nombre: ', style: styleSubtitulo, children: [
              TextSpan(text: pedido.cliente.getFullName(), style: styleTexto)
            ]),
          ),
          RichText(
            text: TextSpan(
                text: 'Telefono celular: ',
                style: styleSubtitulo,
                children: [
                  TextSpan(
                      text: pedido.cliente.telefonoCelular, style: styleTexto)
                ]),
          ),
        ],
      ),
    );
  }

  Widget _ubicacion(PedidoModel pedido, BuildContext context) {
    final styleSubtitulo = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: Colors.black);
    final styleTexto =
        TextStyle(height: 1.5, fontSize: 14, fontWeight: FontWeight.normal);

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
          RichText(
            text: TextSpan(
                text: 'Calle y numero: ',
                style: styleSubtitulo,
                children: [
                  TextSpan(text: pedido.direccion, style: styleTexto)
                ]),
          ),
          RichText(
            text: TextSpan(text: 'Referencia: ', style: styleSubtitulo, children: [
              TextSpan(text: pedido.referencia, style: styleTexto)
            ]),
          ),
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

  Widget _contenido(PedidoModel pedido) {
    final styleSubtitulo = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: Colors.black);
    final styleTexto =
        TextStyle(height: 1.5, fontSize: 14, fontWeight: FontWeight.normal);

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
          RichText(
            text: TextSpan(text: 'Fecha: ', style: styleSubtitulo, children: [
              TextSpan(text: pedido.getFechaFormateada(), style: styleTexto)
            ]),
          ),
          RichText(
            text: TextSpan(text: 'Hora: ', style: styleSubtitulo, children: [
              TextSpan(text: pedido.getHora(), style: styleTexto)
            ]),
          ),
          RichText(
            text: TextSpan(text: 'Tipo: ', style: styleSubtitulo, children: [
              TextSpan(text: pedido.tipoEntrega, style: styleTexto)
            ]),
          ),
          RichText(
            text: TextSpan(
                text: 'Total: ',
                style: styleSubtitulo,
                children: [TextSpan(text: 'Bs.${pedido.total}', style: styleTexto)]),
          ),
          RichText(
            text: TextSpan(
                text: 'Observacion: ',
                style: styleSubtitulo,
                children: [
                  TextSpan(
                      text: pedido.observacion ?? 'No registrado',
                      style: styleTexto)
                ]),
          ),
          RichText(
            text: TextSpan(
                text: 'Estado: ',
                style: styleSubtitulo,
                children: [TextSpan(text: pedido.estado, style: styleTexto)]),
          ),
          RichText(
            text: TextSpan(text: 'Creado el: ', style: styleSubtitulo, children: [
              TextSpan(text: pedido.fechaHora, style: styleTexto)
            ]),
          ),
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
}
