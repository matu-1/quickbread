import 'package:flutter/material.dart';
import 'package:quickbread/src/constants/message_exception.dart';
import 'package:quickbread/src/constants/path.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/pedido_detalle_page.dart';
import 'package:quickbread/src/providers/pedido_provider.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';
import 'package:quickbread/src/widgets/chip_custom.dart';
import 'package:quickbread/src/widgets/error_custom.dart';

class PedidoPage extends StatelessWidget {
  final _pedidoProvider = new PedidoProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _pedidoList(),
    );
  }

  Widget _pedidoList() {
    // List<PedidoModel> pedidos = pedidosFromJsonList(pedidosData);
    final _prefs = new PreferenciasUsuario();
    if (_prefs.usuario.rol != 'cliente')
      return ErrorCustom(message: 'Debe ingresar como un cliente');
    return FutureBuilder(
      future: _pedidoProvider.getByCliente(),
      builder:
          (BuildContext context, AsyncSnapshot<List<PedidoModel>> snapshot) {
        if (snapshot.hasData) {
          final pedidos = snapshot.data;

          if (pedidos.isEmpty)
            return ErrorCustom(message: MessageException.noData);

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      PedidoDetallePage.routeName,
                      arguments: pedidos[index]),
                  onLongPress: () => showAnularDialog(context),
                  child: _pedidoBox(pedidos[index], context));
            },
          );
        } else if (snapshot.hasError) {
          return ErrorCustom(message: snapshot.error.toString());
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _pedidoBox(PedidoModel pedido, BuildContext context) {
    final styleTitulo = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: Colors.black);
    final styleTexto =
        TextStyle(height: 1.4, fontSize: 14, fontWeight: FontWeight.normal);
    final stylePrecio =
        TextStyle(height: 1.4, fontSize: 16, fontWeight: FontWeight.normal);

    return Container(
        padding: EdgeInsets.all(15),
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
                image: NetworkImage(pedido.detalles[0].sucursalProducto.producto
                    .getPathImage()),
                height: 70,
                width: 70,
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
                    pedido.getFechaHora(),
                    style: styleTitulo,
                  ),
                  Text(
                    pedido.tipoEntrega,
                    style: styleTexto,
                  ),
                  Text(
                    pedido.getTotal(),
                    style: stylePrecio,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ChipCustom(
                      value: pedido.estado,
                      color: Theme.of(context).accentColor),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      pedido.getCreatedAt(),
                      style: TextStyle(
                        height: 1.3,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
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
                    'CERRAR',
                    style: styleBtnText,
                  )),
              FlatButton(
                  onPressed: () {},
                  child: Text('GUARDAR', style: styleBtnText)),
            ],
          );
        });
  }
}
