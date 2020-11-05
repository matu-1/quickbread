import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/message_exception.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/models/sucursal_model.dart';
import 'package:quickbread/src/models/sucursal_producto_model.dart';
import 'package:quickbread/src/pages/pedido_resumen_page.dart';
import 'package:quickbread/src/pages/producto_detalle_page.dart';
import 'package:quickbread/src/pages/search_page.dart';
import 'package:quickbread/src/providers/producto_provider.dart';
import 'package:quickbread/src/widgets/error_custom.dart';
import 'package:quickbread/src/widgets/producto_basic_box.dart';

class ProductoPage extends StatefulWidget {
  static final routeName = 'producto';

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final _productoProvider = new ProductoProvider();

  @override
  Widget build(BuildContext context) {
    final SucursalModel sucursal = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(sucursal.nombre),
        actions: [
          _badgeAgregados(context),
        ],
      ),
      body: _productoList(sucursal),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .pushNamed(SearchPage.routeName, arguments: sucursal),
        child: Icon(Icons.search),
      ),
    );
  }

  Widget _productoList(SucursalModel sucursal) {
    // List<ProductoModel> productos = productosFromJsonList(productosData);
    bool showCategoria = true;
    return FutureBuilder(
      future: _productoProvider.getAll(sucursal.id),
      builder: (BuildContext context,
          AsyncSnapshot<List<SucursalProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          if (productos.isEmpty)
            return ErrorCustom(message: MessageException.noData);

          return ListView.builder(
            shrinkWrap: true,
            itemCount: productos.length,
            itemBuilder: (BuildContext context, int index) {
              if (index > 0) {
                showCategoria =
                    productos[index - 1].producto.categoria.nombre !=
                            productos[index].producto.categoria.nombre
                        ? true
                        : false;
              } else {
                showCategoria = true;
              }
              return GestureDetector(
                child: Column(
                  children: [
                    if (showCategoria)
                      _seccionHeader(context, productos[index]),
                    ProductoBasicBox(sucuralProducto: productos[index]),
                  ],
                ),
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

  Container _seccionHeader(
      BuildContext context, SucursalProductoModel sucursalProducto) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          // border: Border(
          //     bottom:
          //         BorderSide(width: 1, color: Theme.of(context).accentColor))
          ),
      child: Text(sucursalProducto.producto.categoria.nombre.toUpperCase(),
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 16,
              fontWeight: FontWeight.w600)),
    );
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
