import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/common_text.dart';
import 'package:quickbread/src/constants/message_exception.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/models/sucursal_model.dart';
import 'package:quickbread/src/models/sucursal_producto_model.dart';
import 'package:quickbread/src/pages/pedido_resumen_page.dart';
import 'package:quickbread/src/pages/producto_detalle_page.dart';
import 'package:quickbread/src/pages/search_page.dart';
import 'package:quickbread/src/providers/producto_provider.dart';
import 'package:quickbread/src/widgets/error_custom.dart';
import 'package:quickbread/src/widgets/producto_basic_box.dart';
import 'package:quickbread/src/pages/sucursal_info_page.dart';

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

    return WillPopScope(
      onWillPop: () => _confirmarSalir(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(sucursal.nombre),
          actions: [
            _badgeAgregados(context),
            IconButton(
                icon: Icon(Icons.info),
                onPressed: () => Navigator.of(context)
                    .pushNamed(SucursalInfoPage.routeName, arguments: sucursal))
          ],
        ),
        body: Column(
          children: [
            if (!sucursal.isAvailable()) _cerradoContent(),
            Expanded(child: _productoList(sucursal)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: sucursal.isAvailable()
              ? () => Navigator.of(context)
                  .pushNamed(SearchPage.routeName, arguments: sucursal)
              : null,
          child: Icon(Icons.search),
        ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showCategoria)
                      _seccionHeader(context, productos[index]),
                    ProductoBasicBox(sucuralProducto: productos[index]),
                  ],
                ),
                onTap: () => sucursal.isAvailable()
                    ? Navigator.of(context).pushNamed(
                        ProductoDetallePage.routeName,
                        arguments: productos[index])
                    : null,
              );
            },
          );
        } else if (snapshot.hasError) {
          final dynamic error = snapshot.error;
          return ErrorCustom(message: '${error.message}');
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
      child: Text(sucursalProducto.producto.categoria.nombre.toUpperCase(),
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 16,
              fontWeight: FontWeight.w500)),
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

  Widget _cerradoContent() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(paddingUI),
      decoration: BoxDecoration(color: Colors.red.withOpacity(0.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cerrado',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.4,
                color: Theme.of(context).errorColor),
          ),
          Text(
            'No es posible realizar pedidos',
            style: TextStyle(color: Theme.of(context).errorColor, height: 1.4),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmarSalir(BuildContext context) async {
    final btnTextColor = Theme.of(context).primaryColor;
    final pedido = Provider.of<PedidoModel>(context, listen: false);

    if (pedido.detalles.length == 0) return true;
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('¿Estas seguro de salir?'),
              content: Text('Si lo haces, se eliminará tu pedido'),
              actions: [
                FlatButton(
                    textColor: btnTextColor,
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(CommonText.no)),
                FlatButton(
                    textColor: btnTextColor,
                    onPressed: () {
                      pedido.reset();
                      Navigator.of(context).pop(true);
                    },
                    child: Text('SI, SALIR'))
              ],
            ));
  }
}
