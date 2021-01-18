import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/common_text.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/models/ubicacion_model.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';
import 'package:quickbread/src/widgets/boton_custom.dart';
import 'package:quickbread/src/widgets/mapa_custom.dart';

class PedidoUbicacion extends StatefulWidget {
  static final routeName = 'pedidoUbicacion';

  @override
  _PedidoUbicacionState createState() => _PedidoUbicacionState();
}

class _PedidoUbicacionState extends State<PedidoUbicacion> {
  LatLng _miUbicacion = new LatLng(-17.850553, -63.113256);
  final styleTitulo = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  final formKey = GlobalKey<FormState>();
  final _prefs = new PreferenciasUsuario();
  final UbicacionModel _ubicacion = new UbicacionModel();
  PedidoModel _pedido;

  @override
  void initState() {
    if (_prefs.ubicacion != null) _miUbicacion = _prefs.ubicacion.getLatLng();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _pedido = Provider.of<PedidoModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Ubicación entrega'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _contenedorMapa(),
          _contenedorBtn(),
          // _formulario(),
        ],
      ),
    );
  }

  Widget _contenedorBtn() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¿Esta es tu ubicación?',
              style: TextStyle(fontSize: sizeTituloUI),
            ),
            Container(
                padding: EdgeInsets.all(paddingUI),
                child: BotonCustom(
                    titulo: CommonText.confirm, onPressed: showFormDialog))
          ],
        ),
      ),
    );
  }

  void showFormDialog() {
    final colorBtnText = Theme.of(context).primaryColor;

    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Detalle de dirección'),
              content: _formulario(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              actions: [
                FlatButton(
                    textColor: colorBtnText,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(CommonText.close)),
                FlatButton(
                    textColor: colorBtnText,
                    onPressed: _guardar,
                    child: Text(
                      CommonText.acept,
                    )),
              ],
            ));
  }

  Widget _formulario() {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              initialValue: _prefs.ubicacion?.direccion,
              decoration: InputDecoration(
                  labelText: 'Calle y número *', hintText: 'Ej. Paurito 23'),
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
          ],
        ),
      ),
    );
  }

  Widget _contenedorMapa() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.65,
      child: MapCustom(
        showCurrentPosition: _prefs.ubicacion == null ? true : false,
        initialPosition: _miUbicacion,
        onMove: (latlng) {
          _miUbicacion = latlng;
        },
      ),
    );
  }

  void _guardar() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    _ubicacion.coordenada =
        '${_miUbicacion.latitude}, ${_miUbicacion.longitude}';
    _prefs.ubicacion = _ubicacion;
    _pedido.setUbicacion(_ubicacion);
    final isPedidoCreate = ModalRoute.of(context).settings.arguments;
    Navigator.of(context).pop();
    if (isPedidoCreate != null) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    }
  }
}
