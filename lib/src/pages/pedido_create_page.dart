import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/providers/pedido_provider.dart';
import 'package:quickbread/src/utils/utils.dart';
import 'package:quickbread/src/widgets/boton_custom.dart';

class PedidoCreatePage extends StatefulWidget {
  static final routeName = 'pedidoCreate';

  @override
  _PedidoCreatePageState createState() => _PedidoCreatePageState();
}

class _PedidoCreatePageState extends State<PedidoCreatePage> {
  int _tipoId;
  String _fecha;
  String _hora;
  TextEditingController _textFieldFecha = TextEditingController();
  TextEditingController _textFieldHora = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final styleTitulo = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  PedidoModel _pedido;
  final _pedidoProvider = new PedidoProvider();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    _pedido = Provider.of<PedidoModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Crear pedido'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _entradaFecha(),
                  SizedBox(
                    height: 20,
                  ),
                  _entradaHora(),
                  SizedBox(
                    height: 20,
                  ),
                  _selectTipo(),
                  SizedBox(
                    height: 40,
                  ),
                  BotonCustom(
                      titulo: 'ENVIAR PEDIDO', onPressed: _registrarPedido)
                ],
              ),
            )),
      ),
    );
  }

  Widget _entradaFecha() {
    return TextFormField(
      controller: _textFieldFecha,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        labelText: 'Fecha *',
        icon: Icon(Icons.calendar_today),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
      validator: (value) {
        if (value.length == 0) return 'La fecha es obligatoria';
        return null;
      },
      onSaved: (value) => _pedido.fecha = value,
    );
  }

  Widget _entradaHora() {
    return TextFormField(
      controller: _textFieldHora,
      decoration: InputDecoration(
        labelText: 'Hora *',
        icon: Icon(Icons.timer),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectTime(context);
      },
      validator: (value) {
        if (value.length == 0) return 'La hora es obligatoria';
        return null;
      },
      onSaved: (value) => _pedido.hora = value,
    );
  }

  Widget _selectTipo() {
    return DropdownButtonFormField(
        value: _tipoId,
        decoration: InputDecoration(
            labelText: 'Tipo entrega *', icon: Icon(Icons.directions_car)),
        items: [
          DropdownMenuItem(
            child: Text('A domicilio'),
            value: 1,
          ),
          DropdownMenuItem(
            child: Text('Recoger al local'),
            value: 2,
          ),
        ],
        onSaved: (value) => setState(() => _pedido.tipoEntregId = value),
        onChanged: (value) => setState(() => _tipoId = value),
        validator: (value) {
          if (value == null) return 'El tipo es obligatoria';
          return null;
        });
  }

  void _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now(),
      lastDate: new DateTime(2025),
      // locale: Locale('es')
    );
    if (picked != null) {
      setState(() {
        _fecha = picked.toString();
        _textFieldFecha.text = _fecha.substring(0, 10);
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _hora = '${picked.hour}:${picked.minute}';
        _textFieldHora.text = _hora;
      });
    }
  }

  void _registrarPedido() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    try {
      await _pedidoProvider.create(_pedido);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
    } catch (e) {
      showSnackbar(e.message, _scaffoldKey);
    }
  }

  bool isValid() {
    if (_fecha != null && _hora != null && _tipoId != null)
      return true;
    else
      return false;
  }
}
