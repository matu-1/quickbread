import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapaPage extends StatelessWidget {
  final LatLng coordenada;
  final String titulo;
  MapaPage({@required this.coordenada, @required this.titulo});

  @override
  Widget build(BuildContext context) {
    getPosicionActual();

    return Scaffold(
      appBar: AppBar(
        title: Text(this.titulo),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(target: coordenada, zoom: 16.0),
        compassEnabled: true,
        markers: _markerCreate(),
      ),
    );
  }

  Set<Marker> _markerCreate() {
    Set<Marker> marker = new Set();
    marker.add(Marker(
        markerId: MarkerId('coordenada'),
        position: coordenada,
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)));
    return marker;
  }

  void getPosicionActual() async {
    await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
