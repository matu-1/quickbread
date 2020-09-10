import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class MapaPage extends StatefulWidget {
  final LatLng coordenada;

  MapaPage({@required this.coordenada});

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      body: _contenedorMapa(),
    );
  }

  Widget _contenedorMapa() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: widget.coordenada,
            zoom: 15.0,
          ),
          layers: [
            _crearMapa(),
            _crearMarcadores(),
          ],
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
          point: widget.coordenada,
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
      LatLng latlng = LatLng(position.latitude, position.longitude);
      print(latlng);
      _mapController.move(latlng, 15);
    } catch (e) {
      print('Ups ocurrio un error');
    }
  }
}
