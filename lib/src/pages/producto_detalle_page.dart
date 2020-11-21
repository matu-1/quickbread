import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/path.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/models/producto_model.dart';
import 'package:quickbread/src/models/sucursal_producto_model.dart';
import 'package:quickbread/src/pages/pedido_resumen_page.dart';
import 'package:quickbread/src/widgets/boton_custom.dart';
import 'package:quickbread/src/utils/utils.dart' as utils;
import 'package:quickbread/src/widgets/chip_custom.dart';

class ProductoDetallePage extends StatelessWidget {
  static final routeName = 'productoDetalle';
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final SucursalProductoModel sucursalProducto =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: _contenido(sucursalProducto, context)),
              Container(
                padding: EdgeInsets.all(paddingUI),
                child: BotonCustom(
                  titulo: 'SELECCIONAR PAN',
                  onPressed: () =>
                      _cantidadModalBottom(context, sucursalProducto),
                ),
              )
            ],
          ),
          _appbar(context),
        ],
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    return Container(
      height: 56 + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.black26,
            Colors.transparent,
          ])),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop())
          ],
        ),
      ),
    );
  }

  Widget _contenido(SucursalProductoModel producto, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imagen(producto, context),
          _tituloContainer(producto.producto, context),
          _divider(),
          _descripcion(producto.producto),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _imagen(SucursalProductoModel producto, BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Hero(
      tag: producto.id,
      child: FadeInImage(
        placeholder: AssetImage(pathLoadingLong),
        image: NetworkImage(producto.producto.getPathImage()),
        height: size.height * 0.35,
        width: double.infinity,
        fit: BoxFit.cover,
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

  Widget _tituloContainer(ProductoModel producto, BuildContext context) {
    final styleTitulo =
        TextStyle(fontSize: 27, fontWeight: FontWeight.w600, height: 1.3);
    final stylePrecio = TextStyle(fontSize: 20, height: 1.3);

    return Padding(
      padding: EdgeInsets.all(paddingUI),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            producto.nombre,
            style: styleTitulo,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                producto.getPrecio(),
                style: stylePrecio,
              ),
              ChipCustom(
                value: producto.categoria.nombre,
                color: Theme.of(context).accentColor,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _descripcion(ProductoModel producto) {
    final styleTitulo =
        TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3);
    final styleBody = TextStyle(height: 1.3);

    return Padding(
      padding: EdgeInsets.all(paddingUI),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descripcion',
            style: styleTitulo,
          ),
          Text(
            producto.descripcion,
            style: styleBody,
          )
        ],
      ),
    );
  }

  void _cantidadModalBottom(
      BuildContext context, SucursalProductoModel producto) {
    final pedido = Provider.of<PedidoModel>(context, listen: false);
    if (pedido.existProducto(producto)) return showMessage('Ya se agrego !!');
    String cantidad;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text('Agrege la cantidad'),
                content: Form(
                  key: formKey,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Cantidad *',
                          ),
                          onSaved: (value) => cantidad = value,
                          validator: (value) {
                            if (utils.isNumeric(value) && int.parse(value) > 0) return null;
                            return 'Debe ser un numero';
                          },
                        )
                      ],
                    ),
                  ),
                ),
                actions: [
                  FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('CERRAR')),
                  FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (!formKey.currentState.validate()) return;
                        formKey.currentState.save();
                        _agregarProducto(context, cantidad, producto);
                      },
                      child: Text('ACEPTAR')),
                ],
              );
            },
          );
        });
  }

  void _agregarProducto(
      BuildContext context, String cantidad, SucursalProductoModel producto) {
    final pedido = Provider.of<PedidoModel>(context, listen: false);
    int newCantidad = int.parse(cantidad);
    Navigator.of(context).pop();
    pedido.add(DetallePedidoModel(
        cantidad: newCantidad,
        sucursalProducto: producto,
        subtotal: producto.producto.precio * newCantidad));
    Navigator.of(context).pushNamed(PedidoResumenPage.routeName);
  }

  void showMessage(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }
}
