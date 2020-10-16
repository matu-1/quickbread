import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickbread/src/constants/common_page.dart';
import 'package:quickbread/src/models/ubicacion_model.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/pages/pedido_create_page.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';
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
  final _prefs = new PreferenciasUsuario();
  final UbicacionModel _ubicacion = new UbicacionModel();

  @override
  void initState() {
    if(_prefs.ubicacion != null) _miUbicacion = _prefs.ubicacion.getLatLng();
    super.initState();
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
              initialValue: _prefs.ubicacion?.direccion,
              decoration: InputDecoration(
                  labelText: 'Calle y numero *', hintText: 'Ej. Paurito 23'),
              onSaved: (value) => _ubicacion.direccion = value,
              validator: (value) {
                if (value.length > 0) return null;
                return 'Es obligatorio';
              },
            ),
            TextFormField(
              initialValue: _prefs.ubicacion?.referencia,
              decoration: InputDecoration(
                  labelText: 'Referencia *',
                  hintText: 'Ej. casa azul al lado de la cancha'),
              onSaved: (value) => _ubicacion.referencia = value,
              validator: (value) {
                if (value.length > 0) return null;
                return 'Es obligatorio';
              },
            ),
            SizedBox(height: 40),
            BotonCustom(
              titulo: saveC,
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
        showCurrentPosition: _prefs.ubicacion == null ? true : false,
        initialPosition: _prefs.ubicacion == null
            ? LatLng(-17.850553, -63.113256)
            : _prefs.ubicacion.getLatLng(),
        onMove: (latlng) {
          _miUbicacion = latlng;
        },
      ),
    );
  }

  void _siguiente() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    _ubicacion.coordenada =
        '${_miUbicacion.latitude}, ${_miUbicacion.longitude}';
    _prefs.ubicacion = _ubicacion;
    // Navigator.of(context).pushNamed(PedidoCreatePage.routeName);
    Navigator.pushReplacementNamed(context, HomePage.routeName);
  }
}
