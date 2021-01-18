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

class ProductoDetallePage extends StatefulWidget {
  static final routeName = 'productoDetalle';

  @override
  _ProductoDetallePageState createState() => _ProductoDetallePageState();
}

class _ProductoDetallePageState extends State<ProductoDetallePage> {
  final styleTitulo =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4);
  final styleBody = TextStyle(height: 1.4);
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int cantidad = 1;
  SucursalProductoModel sucursalProducto;

  @override
  Widget build(BuildContext context) {
    sucursalProducto = ModalRoute.of(context).settings.arguments;

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
                  titulo: 'AGREGAR PRODUCTO',
                  onPressed: () =>
                      _agregarProducto(context, cantidad, sucursalProducto),
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
          _tituloContent(producto.producto, context),
          _divider(),
          _descripcion(producto.producto),
          _divider(),
          _cantidadContent(producto, context),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _cantidadContent(
      SucursalProductoModel sucursalProducto, BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.all(paddingUI),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cantidad',
            style: styleTitulo,
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: color, width: 1)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    color: color,
                    onPressed: cantidad > 1 ? disminuirCantidad : null,
                    disabledColor: Colors.grey[300],
                  ),
                  GestureDetector(
                    onTap: () =>
                        _cantidadModalBottom(context, sucursalProducto),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '${this.cantidad}',
                        style: TextStyle(color: color),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.add),
                      color: color,
                      onPressed: incrementarCantidad)
                ],
              ),
            ),
          )
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

  Widget _tituloContent(ProductoModel producto, BuildContext context) {
    final styleTitulo =
        TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.4);
    final stylePrecio = TextStyle(fontSize: 20, height: 1.4);

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
    return Padding(
      padding: EdgeInsets.all(paddingUI),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descripción',
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Unidades'),
            content: Form(
              key: formKey,
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: '$cantidad',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Cantidad *',
                      ),
                      onSaved: (value) =>
                          setState(() => cantidad = num.parse(value)),
                      validator: (value) {
                        if (utils.isNumeric(value) && int.parse(value) > 0)
                          return null;
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
                    Navigator.of(context).pop();
                  },
                  child: Text('ACEPTAR')),
            ],
          );
        });
  }

  void _agregarProducto(
      BuildContext context, int cantidad, SucursalProductoModel producto) {
    final pedido = Provider.of<PedidoModel>(context, listen: false);
    if (pedido.existProducto(producto))
      return utils.showSnackbar('Ya se agrego !!', _scaffoldKey);

    if (cantidad > producto.stock) {
      return utils.showSnackbar(
          'No se cuenta con stock suficiente, stock = ${producto.stock}',
          _scaffoldKey);
    }
    pedido.add(DetallePedidoModel(
        cantidad: cantidad,
        sucursalProducto: producto,
        subtotal: producto.producto.precio * cantidad));
    Navigator.of(context).pushNamed(PedidoResumenPage.routeName);
  }

  void incrementarCantidad() {
    setState(() {
      cantidad++;
    });
  }

  void disminuirCantidad() {
    if (cantidad == 1) return;
    setState(() {
      cantidad--;
    });
  }
}
