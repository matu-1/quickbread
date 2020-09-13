import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/pages.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/models/producto_model.dart';
import 'package:quickbread/src/pages/pedido_resumen_page.dart';
import 'package:quickbread/src/pages/producto_detalle_page.dart';
import 'package:quickbread/src/providers/producto_provider.dart';
import 'package:quickbread/src/widgets/error_custom.dart';

class ProductoPage extends StatelessWidget {
  static final routeName = 'producto';
  final _productoProvider = new ProductoProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panes'),
        actions: [
          _badgeAgregados(context),
        ],
      ),
      body: _productoList(),
    );
  }

  Widget _productoList() {
    // List<ProductoModel> productos = productosFromJsonList(productosData);
    return FutureBuilder(
      future: _productoProvider.getAll(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          List<ProductoModel> productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: _productoBox(productos[index]),
                onTap: () => Navigator.of(context).pushNamed(
                    ProductoDetallePage.routeName,
                    arguments: productos[index]),
              );
            },
          );
        } else if (snapshot.hasError) {
          return ErrorCustom(message: '${snapshot.error}'.substring(11));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _productoBox(ProductoModel producto) {
    final styleTitulo =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3);
    final styleTexto = TextStyle(height: 1.3, color: Colors.grey[600]);
    final stylePrecio = TextStyle(height: 1.3);

    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
        child: Row(
          children: [
            Hero(
              tag: producto.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: FadeInImage(
                  placeholder: AssetImage(pathLoading),
                  image: NetworkImage(producto.getPathImage()),
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
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
                    producto.nombre,
                    style: styleTitulo,
                  ),
                  Text(
                    producto.descripcion,
                    style: styleTexto,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    producto.getPrecio(),
                    style: stylePrecio,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _badgeAgregados(BuildContext context) {
    final pedido = Provider.of<PedidoModel>(context);
    if (pedido.detalles.length == 0) return Container();

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.of(context)
                .pushNamed(PedidoResumenPage.routeName, arguments: true)),
        Positioned(
          top: 10,
          right: 5,
          child: Container(
            width: 15,
            height: 15,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor, shape: BoxShape.circle),
            child: Text(
              pedido.detalles.length.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
