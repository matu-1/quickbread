import 'package:flutter/material.dart';
import 'package:quickbread/src/constants/message_exception.dart';
import 'package:quickbread/src/models/sucursal_model.dart';
import 'package:quickbread/src/models/sucursal_producto_model.dart';
import 'package:quickbread/src/providers/producto_provider.dart';
import 'package:quickbread/src/widgets/error_custom.dart';
import 'package:quickbread/src/widgets/producto_basic_box.dart';

class SearchPage extends StatefulWidget {
  static final routeName = 'search';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _productoProvider = new ProductoProvider();
  List<SucursalProductoModel> _sucursalProductos = [];
  String query = '';
  List<SucursalProductoModel> _sucursalProductosSearched = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final SucursalModel sucursal = ModalRoute.of(context).settings.arguments;
    _productoProvider.getAll(sucursal.id).then((value) {
      _sucursalProductos = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _header(),
      ),
      body: _productoList(),
    );
  }

  Widget _header() {
    return Row(
      children: <Widget>[
        Icon(Icons.search),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Buscar',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                query = value;
                if (query.isNotEmpty) _search();
                setState(() {});
              }),
        )
      ],
    );
  }

  Widget _productoList() {
    if (query.isEmpty) return Container();
    if (query.isNotEmpty && _sucursalProductosSearched.length == 0)
      return ErrorCustom(message: MessageException.noResult);

    return ListView.builder(
      itemCount: _sucursalProductosSearched.length,
      itemBuilder: (BuildContext context, int index) {
        return ProductoBasicBox(
            sucuralProducto: _sucursalProductosSearched[index]);
      },
    );
  }

  void _search() {
    String newQuery = query.toUpperCase();
    _sucursalProductosSearched = _sucursalProductos.where((element) {
      final newElement = element.producto.nombre.toUpperCase();
      return newElement.contains(newQuery);
    }).toList();

    setState(() {});
  }
}
