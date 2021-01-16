import 'package:flutter/material.dart';

class AyudaPage extends StatelessWidget {
  static final routeName = 'ayuda';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayuda'),
      ),
      body: Container(
        child: ListView(
          children: [
            Divider(),
            ListTile(
              title: Text('Anular pedido de entrega de mas de 24 horas'),
              subtitle: Text('Los pedidos se pueden anular 5 horas antes de la entrega.'),
            ),
            Divider(),
            ListTile(
              title: Text('Anular pedido de entrega inmediata'),
              subtitle: Text('Los pedidos se pueden anular 5 minutos antes de la entrega.'),
            ),
            Divider(),
            ListTile(
              title: Text('Telefono celular'),
              subtitle: Text('Llamar al numero 78454525 para cualquier consulta.'),
            ),
            Divider(),
            ListTile(
              title: Text('Motivos de anulacion de pedidos'),
              subtitle: Text('EL pedido no esta en las horas laborales o dias.'),
            )
          ],
        ),
      ),
    );
  }
}
