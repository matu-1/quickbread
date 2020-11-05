import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/common_text.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/utils/utils.dart';
import 'package:quickbread/src/widgets/boton_custom.dart';

class CuandoPage extends StatefulWidget {
  static final routeName = 'cuando';

  @override
  _CuandoPageState createState() => _CuandoPageState();
}

class _CuandoPageState extends State<CuandoPage> {
  PedidoModel _pedido;
  int opcion = 1;
  String fecha;
  String hora;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pedido = Provider.of<PedidoModel>(context);
    if (_pedido.fecha != null) {
      opcion = 2;
      fecha = _pedido.fecha;
      hora = _pedido.hora;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Para cuando'),
      ),
      body: Column(
        children: [
          _ahora(),
          Divider(
            height: 0.5,
          ),
          _programar(),
          if (opcion == 2) _contenedorProgramacion(),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(paddingUI),
            child: BotonCustom(
                titulo: CommonText.save,
                onPressed: isValidoProgramacion() ? guardar : null),
          )
        ],
      ),
    );
  }

  Widget _ahora() {
    return InkWell(
      onTap: () {
        setState(() {
          opcion = 1;
        });
      },
      child: Container(
        padding: EdgeInsets.all(paddingUI),
        child: Row(
          children: [
            Icon(Icons.timer),
            SizedBox(
              width: 20,
            ),
            Text('Lo mas antes posible'),
            Spacer(),
            if (opcion == 1)
              Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _programar() {
    return InkWell(
      onTap: () {
        setState(() {
          opcion = 2;
        });
      },
      child: Container(
        padding: EdgeInsets.all(paddingUI),
        child: Row(
          children: [
            Icon(Icons.calendar_today),
            SizedBox(
              width: 20,
            ),
            Text('Programar un pedido'),
            Spacer(),
            if (opcion == 2)
              Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _contenedorProgramacion() {
    final horas = generarHora(18, false);
    return Container(
      padding: EdgeInsets.all(paddingUI),
      margin: EdgeInsets.all(paddingUI),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 3)],
          color: Colors.white),
      child: Column(
        children: [
          DropdownButton(
            value: fecha,
            isExpanded: true,
            items: [
              if (fecha == null)
                DropdownMenuItem(
                  child: Text('Seleccione la Fecha'),
                  value: null,
                ),
              ...generarFecha(7).map(
                (fecha) => DropdownMenuItem(
                  child: Text(getDateShort(fecha)),
                  value: fecha.toString().substring(0, 10),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                fecha = value;
              });
            },
          ),
          DropdownButton(
            value: hora,
            isExpanded: true,
            items: [
              if (hora == null)
                DropdownMenuItem(
                  child: Text('Seleccione la hora'),
                  value: null,
                ),
              for (var i = 0; i < horas.length - 1; i++)
                DropdownMenuItem(
                  child: Text('${horas[i]} - ${horas[i + 1]}'),
                  value: horas[i],
                ),
            ],
            onChanged: (value) {
              setState(() => hora = value);
            },
          )
        ],
      ),
    );
  }

  List<DateTime> generarFecha(int cantidadDias) {
    List<DateTime> fechas = [];
    DateTime hoy = new DateTime.now();
    for (int i = 0; i < cantidadDias; i++) {
      fechas.add(hoy.add(new Duration(days: i)));
    }
    return fechas;
  }

  List<String> generarHora(int horaFIn, bool isHoraActual) {
    List<String> horas = [];
    DateTime hoy;
    if (isHoraActual) {
      hoy = new DateTime.now();
      if (hoy.minute < 30) {
        hoy = new DateTime(hoy.year, hoy.month, hoy.day, hoy.hour + 1, 0, 0);
      } else {
        hoy = new DateTime(hoy.year, hoy.month, hoy.day, hoy.hour + 1, 30, 0);
      }
    } else {
      hoy = new DateTime(2020, 10, 22, 8, 0, 0);
    }
    horas.add(getHora(hoy));
    while (hoy.hour < horaFIn) {
      hoy = hoy.add(new Duration(minutes: 30));
      horas.add(getHora(hoy));
    }
    return horas;
  }

  String getHora(DateTime fecha) {
    return '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  void guardar() {
    if (opcion == 2) {
      _pedido.setFechaHora(fecha, hora);
    } else {
      _pedido.setFechaHora(null, null);
    }
    Navigator.of(context).pop();
  }

  bool isValidoProgramacion() {
    if (opcion == 1) return true;
    if (opcion == 2 && fecha != null && hora != null) return true;
    return false;
  }
}
