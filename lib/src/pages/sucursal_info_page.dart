import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quickbread/src/constants/fecha.dart';
import 'package:quickbread/src/constants/path.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/sucursal_model.dart';
import 'package:quickbread/src/utils/utils.dart';

class SucursalInfoPage extends StatelessWidget {
  static final routeName = 'sucursalInfo';
  final styleTitulo =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w500, height: 1.4);
  final styleBody = TextStyle(fontSize: 14, height: 1.4);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final SucursalModel sucursal = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Información'),
        actions: [
          IconButton(
              tooltip: 'Enviar mensaje',
              icon: Icon(
                Icons.message,
              ),
              onPressed: () => _launchWhatsapp(sucursal))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sucursalBox(sucursal),
            _divider(),
            _contactoContent(sucursal),
            _divider(),
            _horariosContent(sucursal.getHorariosAtencion()),
            _divider(),
            _ubicacionContent(sucursal),
            _divider()
          ],
        ),
      ),
    );
  }

  Widget _contactoContent(SucursalModel sucursal) {
    return Container(
      padding: EdgeInsets.all(paddingUI),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Contacto (WhatsApp)',
          style: styleTitulo,
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Icon(
              Icons.phone_android,
              color: Colors.grey,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              sucursal.telefono,
              style: styleBody,
            )
          ],
        )
      ]),
    );
  }

  Widget _horariosContent(List<HorarioAtencion> horariosAtencion) {
    return Container(
      padding: EdgeInsets.all(paddingUI),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Horarios',
          style: styleTitulo,
        ),
        SizedBox(
          height: 5,
        ),
        ...horariosAtencion.map((e) => _horarioBox(e)).toList()
      ]),
    );
  }

  Widget _horarioBox(HorarioAtencion horarioAtencion) {
    return Container(
      child: Row(
        children: [
          Text(capitalize(dias[int.parse(horarioAtencion.dia) - 1])),
          Spacer(),
          Text(
            '${horarioAtencion.horaInicio} - ${horarioAtencion.horaFin}',
            style: styleBody,
          )
        ],
      ),
    );
  }

  Widget _ubicacionContent(SucursalModel sucursal) {
    return Container(
      padding: EdgeInsets.all(paddingUI),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ubicación',
            style: styleTitulo,
          ),
          SizedBox(
            height: 5,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 180,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: sucursal.getCoordenada(), zoom: 16.0),
                markers: _markerCreate(sucursal.getCoordenada()),
                zoomControlsEnabled: false,
              ),
            ),
          )
        ],
      ),
    );
  }

  Set<Marker> _markerCreate(LatLng coordenada) {
    Set<Marker> marker = new Set();
    marker.add(Marker(
        markerId: MarkerId('coordenada'),
        position: coordenada,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)));
    return marker;
  }

  Padding _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingUI),
      child: Divider(
        height: 1,
        color: Colors.grey[350],
      ),
    );
  }

  Widget _sucursalBox(SucursalModel sucursal) {
    return Container(
      padding: EdgeInsets.all(paddingUI),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FadeInImage(
              placeholder: AssetImage(pathLoading),
              image: NetworkImage(sucursal.getPathImage()),
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sucursal.nombre,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(sucursal.direccion),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _launchWhatsapp(SucursalModel sucursal) async {
    final url =
        'whatsapp://send?phone=+591${sucursal.telefono}&text=holaaa men';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showSnackbar('No se pudo iniciar :(', _scaffoldKey);
    }
  }
}
