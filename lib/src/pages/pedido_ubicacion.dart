import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/pedido_create_page.dart';
import 'package:quickbread/src/widgets/boton_custom.dart';
import 'package:quickbread/src/widgets/mapa_custom.dart';

class PedidoUbicacion extends StatefulWidget {
  static final routeName = 'pedidoUbicacion';

  @override
  _PedidoUbicacionState createState() => _PedidoUbicacionState();
}

class _PedidoUbicacionState extends State<PedidoUbicacion> {
  LatLng _miUbicacion;
  final styleTitulo = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  final formKey = GlobalKey<FormState>();
  PedidoModel _pedido;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pedido = Provider.of<PedidoModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicacion entrega'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _contenedorMapa(),
            _formulario(),
          ],
        ),
      ),
    );
  }

  Widget _formulario() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Calle y numero *', hintText: 'Ej. Paurito 23'),
              onSaved: (value) => _pedido.direccion = value,
              validator: (value) {
                if (value.length > 0) return null;
                return 'Es obligatorio';
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Referencia *',
                  hintText: 'Ej. casa azul al lado de la cancha'),
              onSaved: (value) => _pedido.referencia = value,
              validator: (value) {
                if (value.length > 0) return null;
                return 'Es obligatorio';
              },
            ),
            SizedBox(height: 40),
            BotonCustom(
              titulo: 'SIGUIENTE',
              onPressed: _siguiente,
            )
          ],
        ),
      ),
    );
  }

  Widget _contenedorMapa() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.35,
      child: MapCustom(
        onMove: (latlng) {
          _miUbicacion = latlng;
        },
      ),
    );
  }

  void _siguiente() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    _pedido.coordenada = _miUbicacion.toString();
    Navigator.of(context).pushNamed(PedidoCreatePage.routeName);
  }
}

