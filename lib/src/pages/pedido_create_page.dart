import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/cuando_page.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/pages/pedido_ubicacion.dart';
import 'package:quickbread/src/providers/pedido_provider.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';
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
  final styleTitulo =
      TextStyle(fontSize: sizeSubtituloUI, fontWeight: FontWeight.w600);
  PedidoModel _pedido;
  final _pedidoProvider = new PedidoProvider();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog _pr;
  PreferenciasUsuario _prefs = new PreferenciasUsuario();
  String _tipo = 'Al domicilio';

  @override
  void didChangeDependencies() {
    _pedido = Provider.of<PedidoModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _pr = new ProgressDialog(context, isDismissible: false);
    _pr.style(message: 'Espere por favor');

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Crear pedido'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cuandoInput(),
                Divider(
                  height: 0.5,
                ),
                _tipoEntregaInput(),
                Divider(
                  height: 0.5,
                ),
                Opacity(opacity: 0.3, child: _formaPagoInput()),
                Divider(
                  height: 0.5,
                ),
                _ubicacionInput(),
                // _entradaFecha(),
                // _entradaHora(),
                // _selectTipo(),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingUI),
                  child: BotonCustom(
                      titulo: 'ENVIAR PEDIDO', onPressed: _registrarPedido),
                )
              ],
            )),
      ),
    );
  }

  Widget _cuandoInput() {
    return Container(
      padding: EdgeInsets.all(paddingUI),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Para cuando',
                style: styleTitulo,
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pushNamed(CuandoPage.routeName),
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(_pedido.fecha == null
              ? 'Lo antes posible'
              : _pedido.getFechaHoraCorta()),
        ],
      ),
    );
  }

  Widget _formaPagoInput() {
    return Container(
      padding: EdgeInsets.all(paddingUI),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Forma de pago',
                style: styleTitulo,
              ),
              Icon(
                Icons.edit,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text('En efectivo'),
        ],
      ),
    );
  }

  Widget _tipoEntregaInput() {
    return Container(
      padding: EdgeInsets.all(paddingUI),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tipo de entrega',
                style: styleTitulo,
              ),
              GestureDetector(
                onTap: () {
                  _showTipoModalBottom();
                },
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(_tipo),
        ],
      ),
    );
  }

  Widget _ubicacionInput() {
    return Container(
      padding: EdgeInsets.all(paddingUI),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ubicacion',
                style: styleTitulo,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(PedidoUbicacion.routeName, arguments: true);
                },
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(_prefs.ubicacion.getUbicacion()),
        ],
      ),
    );
  }

  void _showTipoModalBottom() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        context: context,
        builder: (BuildContext context) {
          return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(paddingUI),
                    child: Text(
                      'Seleccione',
                      style: TextStyle(
                          fontSize: sizeTituloUI, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingUI),
                    child: Divider(
                      height: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _tipo = 'Al domicilio';
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(paddingUI),
                      child: Text(
                        'Al domicilio',
                        style: styleTitulo,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _tipo = 'Recoger al local';
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(paddingUI),
                      child: Text(
                        'Recoger al local',
                        style: styleTitulo,
                      ),
                    ),
                  ),
                ],
              ));
        });
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
            labelText: 'Tipo de entrega *', icon: Icon(Icons.directions_car)),
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
    _pr.show();
    try {
      await _pedidoProvider.create(_pedido);
      _pr.hide();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
    } catch (e) {
      _pr.hide();
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
