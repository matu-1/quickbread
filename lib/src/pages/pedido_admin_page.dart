import 'package:flutter/material.dart';
import 'package:quickbread/src/blocs/pedido_bloc.dart';
import 'package:quickbread/src/constants/path.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/pedido_detalle_admin_page.dart';
import 'package:quickbread/src/widgets/chip_custom.dart';
import 'package:quickbread/src/widgets/error_custom.dart';

class PedidoNuevoPage extends StatelessWidget {
  static final routeName = 'pedidoNuevo';
  final _pedidoBloc = new PedidoBloc();

  @override
  Widget build(BuildContext context) {
    _pedidoBloc.getAll();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _pedidoBloc.getAll)],
      ),
      body: _pedidoList(),
    );
  }

  Widget _pedidoList() {
    // List<PedidoModel> pedidos = pedidosFromJsonList(pedidosData);
    return StreamBuilder(
      stream: _pedidoBloc.pedidoStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<PedidoModel>> snapshot) {
        if (snapshot.hasData) {
          final pedidos = snapshot.data;

          if (pedidos.length == 0)
            return ErrorCustom(message: 'No hay registros');

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      PedidoNuevoDetallePage.routeName,
                      arguments: pedidos[index]),
                  onLongPress: () => showAnularDialog(context),
                  child: _pedidoBox(pedidos[index], context));
            },
          );
        } else if (snapshot.hasError) {
          return ErrorCustom(message: '${snapshot.error}');
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
                    pedido.cliente.getFullName(),
                    style: styleTitulo,
                  ),
                  Text(
                    pedido.getFechaHora(),
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