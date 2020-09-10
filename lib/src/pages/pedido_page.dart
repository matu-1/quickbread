import 'package:flutter/material.dart';
import 'package:quickbread/src/constants/pages.dart';
import 'package:quickbread/src/constants/pedidos.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/pedido_detalle_page.dart';
import 'package:quickbread/src/widgets/chip_custom.dart';

class PedidoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _pedidoList(),
    );
  }

  Widget _pedidoList() {
    List<PedidoModel> pedidos = pedidosFromJsonList(pedidosData);

    return ListView.builder(
      itemCount: pedidos.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(PedidoDetallePage.routeName, arguments: pedidos[index] ),
          onLongPress: () => showAnularDialog(context),
          child: _pedidoBox(pedidos[index], context)
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
                image: NetworkImage(pedido.detalles[0].producto.foto),
                height: 80,
                width: 80,
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
                  Text(pedido.getFechaHora(), style: styleTitulo,),
                  Text(pedido.tipoEntrega, style: styleTexto,),
                  Text(pedido.getTotal(), style: stylePrecio,),
                  ChipCustom(value: pedido.estado, color: Theme.of(context).accentColor),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      pedido.fechaHora,
                      style: TextStyle(
                          height: 1.3, color: Colors.grey, fontSize: 12, ),
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
