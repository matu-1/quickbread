import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatelessWidget {
  final LatLng coordenada;
  MapaPage({@required this.coordenada});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
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
}
