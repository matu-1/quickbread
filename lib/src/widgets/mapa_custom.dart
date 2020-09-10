import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCustom extends StatefulWidget {
  final Function(LatLng) onMove;
  MapCustom({@required this.onMove});

  @override
  _MapCustomState createState() => _MapCustomState();
}

class _MapCustomState extends State<MapCustom> {
  final _origen = LatLng(-17.850553, -63.113256);
  GoogleMapController _mapController;
  LatLng _myUbicacion = LatLng(-17.844980, -63.111379);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _origen, zoom: 16.0),
          onMapCreated: _onMapCreated,
          compassEnabled: true,
          markers: _markerCreate(),
          onCameraMove: (position) {
            setState(() {
              _myUbicacion = position.target;
            });
            widget.onMove(position.target);
          },
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey[400],
                  blurRadius: 1,
                )
              ], color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: IconButton(
                  icon: Icon(Icons.my_location), onPressed: _myLocation)),
        )
      ],
    );
  }

  Set<Marker> _markerCreate() {
    Set<Marker> marker = new Set();
    marker.add(Marker(
        markerId: MarkerId('sabe'),
        position: _myUbicacion,
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)));
    return marker;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _myLocation();
  }

  void _myLocation() async {
    try {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      LatLng latlng = LatLng(position.latitude, position.longitude);
      print(latlng);
      _mapController.animateCamera(CameraUpdate.newLatLng(latlng));
    } catch (e) {
      print('Ups ocurrio un error');
    }
  }
}
