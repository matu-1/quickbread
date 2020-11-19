import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickbread/src/constants/common_text.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/usuario_model.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/providers/usuario_provider.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';
import 'package:quickbread/src/utils/utils.dart';
import 'package:quickbread/src/widgets/boton_custom.dart';

class YoEditPage extends StatefulWidget {
  static final routeName = 'yoEdit';
  @override
  _YoEditPageState createState() => _YoEditPageState();
}

class _YoEditPageState extends State<YoEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _prefs = new PreferenciasUsuario();
  UsuarioModel _usuario;
  final _usuarioProvider = new UsuarioProvider();
  ProgressDialog _pr;

  @override
  Widget build(BuildContext context) {
    _pr = new ProgressDialog(context, isDismissible: false);
    _pr.style(message: CommonText.loading);
    _usuario = _prefs.usuario;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edicion del perfil'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(paddingUI),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _campoNombre(),
                _campoApellido(),
                _campoTelefono(),
                SizedBox(height: 40),
                BotonCustom(
                  titulo: 'GUARDAR',
                  onPressed: _actualizar,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoNombre() {
    return TextFormField(
      initialValue: _usuario.nombre,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(labelText: 'Nombre *'),
      validator: (value) {
        if (value.length >= 2) return null;
        return 'El nombre es obligatorio';
      },
      onSaved: (value) => _usuario.nombre = value,
    );
  }

  Widget _campoApellido() {
    return TextFormField(
      initialValue: _usuario.apellido,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(labelText: 'Apellido *'),
      validator: (value) {
        if (value.length >= 1) return null;
        return 'EL apellido es obligatorio';
      },
      onSaved: (value) => _usuario.apellido = value,
    );
  }

  Widget _campoTelefono() {
    return TextFormField(
      initialValue: _usuario.telefono,
      decoration: InputDecoration(labelText: 'Telefono celular *'),
      validator: (value) {
        if (isNumeric(value)) return null;
        return 'Debe ser un numero';
      },
      onSaved: (value) => _usuario.telefono = value,
    );
  }

  void _actualizar() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    _pr.show();
    try {
      await _usuarioProvider.update(_usuario);
      _pr.hide();
      Navigator.of(context).popUntil(ModalRoute.withName(HomePage.routeName));
    } catch (e) {
      Future.delayed(new Duration(milliseconds: 200), () => _pr.hide());
      showSnackbar(e.message, _scaffoldKey);
    }
  }
}
