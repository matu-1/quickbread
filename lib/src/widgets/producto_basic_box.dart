import 'package:flutter/material.dart';
import 'package:quickbread/src/constants/path.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/sucursal_producto_model.dart';

class ProductoBasicBox extends StatelessWidget {
  final SucursalProductoModel sucuralProducto;

  const ProductoBasicBox({
    Key key,
    @required this.sucuralProducto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styleTitulo =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3);
    final styleTexto = TextStyle(height: 1.3, color: Colors.grey[600]);
    final stylePrecio = TextStyle(height: 1.3);

    return Container(
        padding: EdgeInsets.symmetric(vertical: paddingUI),
        margin: EdgeInsets.symmetric(horizontal: paddingUI),
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(color: Colors.grey[300], width: 0.5))),
        child: Row(
          children: [
            Hero(
              tag: sucuralProducto.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: FadeInImage(
                  placeholder: AssetImage(pathLoading),
                  image: NetworkImage(sucuralProducto.producto.getPathImage()),
                  height: 70,
                  width: 70,
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
                    sucuralProducto.producto.nombre,
                    style: styleTitulo,
                  ),
                  Text(
                    sucuralProducto.producto.descripcion,
                    style: styleTexto,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    sucuralProducto.producto.getPrecio(),
                    style: stylePrecio,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
