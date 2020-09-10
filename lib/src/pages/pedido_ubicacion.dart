import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/pages.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/pedido_create_page.dart';
import 'package:quickbread/src/widgets/TextFormFieldSample.dart';
import 'package:quickbread/src/widgets/boton_custom.dart';

class PedidoUbicacion extends StatefulWidget {
  static final routeName = 'pedidoUbicacion';

  @override
  _PedidoUbicacionState createState() => _PedidoUbicacionState();
}

class _PedidoUbicacionState extends State<PedidoUbicacion> {
  LatLng _latlng = LatLng(-17.846783, -63.112505);
  MapController _mapController = MapController();
  final styleTitulo = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  final formKey = GlobalKey<FormState>();
  PedidoModel _pedido;

  @override
  void initState() {
    super.initState();
    // _myLocation();
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
            SizedBox(
              height: 10,
            ),
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
                labelText: 'Calle y numero *',
                fillColor: Colors.grey[100],
                filled: true,
              ),
              onSaved: (value) => _pedido.direccion = value,
              validator: (value) {
                if (value.length > 0) return null;
                return 'Es obligatorio';
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Referencia *',
                fillColor: Colors.grey[100],
                filled: true,
              ),
              onSaved: (value) => _pedido.referencia = value,
              validator: (value) {
                if (value.length > 0) return null;
                return 'Es obligatorio';
              },
            ),
            SizedBox(height: 40),
            BotonCustom(
              titulo: 'SIGUIENTE',
              onPressed: () => _siguiente(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _contenedorMapa() {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: size.height * 0.35,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: _latlng,
                  zoom: 16.0,
                  onPositionChanged: (position, hasGesture) {
                    if (_latlng != position.center)
                      setState(() => _latlng = position.center);
                  },
                ),
                layers: [
                  _crearMapa(),
                  _crearMarcadores(),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: IconButton(
                      icon: Icon(Icons.my_location), onPressed: _myLocation)),
            )
          ],
        ),
      ],
    );
  }

  TileLayerOptions _crearMapa() {
    return TileLayerOptions(
      urlTemplate: "https://api.tiles.mapbox.com/v4/"
          "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
      additionalOptions: {
        'accessToken':
            'pk.eyJ1IjoibWF0dW0iLCJhIjoiY2s3bnJmYWhlMDEybTNrcDllcTMyem90byJ9.EP7KiAaMljtFfCHAq6hiIg',
        'id': 'mapbox.streets',
      },
    );
  }

  MarkerLayerOptions _crearMarcadores() {
    return MarkerLayerOptions(
      markers: [
        Marker(
          width: 80.0,
          height: 80.0,
          point: _latlng,
          builder: (BuildContext context) => Container(
            child: Icon(
              Icons.place,
              size: 50,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ],
    );
  }

  void _myLocation() async {
    try {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latlng = LatLng(position.latitude, position.longitude);
      });
      print(_latlng);
      _mapController.move(_latlng, 16);
    } catch (e) {
      print('Ups ocurrio un error');
    }
  }

  void _siguiente(BuildContext context) async {
    if (!formKey.currentState.validate()) return;
    Navigator.of(context).pushNamed(PedidoCreatePage.routeName);
    formKey.currentState.save();
    print(_pedido.direccion);
  }
}
