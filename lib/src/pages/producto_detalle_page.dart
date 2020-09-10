import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/pages.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/models/producto_model.dart';
import 'package:quickbread/src/pages/pedido_resumen_page.dart';
import 'package:quickbread/src/widgets/boton_custom.dart';
import 'package:quickbread/src/utils/utils.dart' as utils;
import 'package:quickbread/src/widgets/chip_custom.dart';

class ProductoDetallePage extends StatelessWidget {
  static final routeName = 'productoDetalle';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ProductoModel producto = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          Expanded(child: _contenido(producto, context)),
          Container(
            padding: EdgeInsets.all(padding),
            child: BotonCustom(
              titulo: 'SELECCIONAR PAN',
              onPressed: () => _cantidadModalBottom(context, producto),
            ),
          )
        ],
      ),
    );
  }

  Widget _contenido(ProductoModel producto, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imagen(producto),
          _tituloContainer(producto, context),
          _divider(),
          _descripcion(producto),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _imagen(ProductoModel producto) {
    return Padding(
      padding: EdgeInsets.only(left: padding, right: padding, top: padding),
      child: Hero(
        tag: producto.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
            placeholder: AssetImage(pathLoadingLong),
            image: NetworkImage(producto.foto),
            height: 280,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
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

  Widget _tituloContainer(ProductoModel producto, BuildContext context) {
    final styleTitulo =
        TextStyle(fontSize: 30, fontWeight: FontWeight.w600, height: 1.3);
    final stylePrecio = TextStyle(fontSize: 20, height: 1.3);

    return Padding(
      padding: EdgeInsets.all(padding),
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
      padding: EdgeInsets.all(padding),
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

  void _cantidadModalBottom(BuildContext context, ProductoModel producto) {
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
                            // border: OutlineInputBorder(),
                            fillColor: Colors.grey[100],
                            filled: true,
                          ),
                          onSaved: (value) => cantidad = value,
                          validator: (value) {
                            if (utils.isNumeric(value)) return null;
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
      BuildContext context, String cantidad, ProductoModel producto) {
    final pedido = Provider.of<PedidoModel>(context, listen: false);
    int newCantidad = int.parse(cantidad);
    Navigator.of(context).pop();
    pedido.add(DetallePedidoModel(
        cantidad: newCantidad,
        producto: producto,
        subtotal: producto.precio * newCantidad));
    Navigator.of(context).pushNamed(PedidoResumenPage.routeName);
  }
}
