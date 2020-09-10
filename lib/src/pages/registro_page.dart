import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickbread/src/pages/login_page.dart';
import 'package:quickbread/src/utils/utils.dart' as utils;
import 'package:quickbread/src/models/usuario_model.dart';
import 'package:quickbread/src/widgets/TextFormFieldSample.dart';
import 'package:quickbread/src/widgets/boton_gradient.dart';

class RegistroPage extends StatefulWidget {
  static final routeName = 'registro';

  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  UsuarioModel _usuario = new UsuarioModel();
  ProgressDialog _pr;
  bool _isOcultado = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _pr = new ProgressDialog(context, isDismissible: false);
    _pr.style(message: 'Espere por favor');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Crear cuenta'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _formContainer(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formContainer(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormFieldSample(
          icon: Icon(Icons.assignment_ind),
          hintText: 'CI',
          onSaved: (value) => _usuario.ci = value,
          validator: (value) {
            if (value.length >= 8) return null;
            return 'Minimo 8 caracteres por favor';
          },
        ),
        SizedBox(height: 20),
        TextFormFieldSample(
          textCapitalization: TextCapitalization.words,
          icon: Icon(Icons.person),
          hintText: 'Nombre',
          onSaved: (value) => _usuario.nombre = value,
          validator: (value) {
            if (value.length >= 3) return null;
            return 'Minimo 3 caracteres por favor';
          },
        ),
        SizedBox(height: 20),
        TextFormFieldSample(
          textCapitalization: TextCapitalization.words,
          icon: Icon(Icons.perm_identity),
          hintText: 'Apellido',
          onSaved: (value) => _usuario.apellido = value,
          validator: (value) {
            if (value.length >= 3) return null;
            return 'Minimo 3 caracteres por favor';
          },
        ),
        SizedBox(height: 20),
        TextFormFieldSample(
          textCapitalization: TextCapitalization.words,
          textInputType: TextInputType.number,
          icon: Icon(Icons.phone_android),
          hintText: 'Telefono',
          onSaved: (value) => _usuario.telefono = value,
          validator: (value) {
            if (utils.isNumeric(value)) return null;
            return 'Debe ser un numero';
          },
        ),
        SizedBox(height: 20),
        TextFormFieldSample(
          icon: Icon(Icons.directions),
          hintText: 'Direccion',
          onSaved: (value) => _usuario.direccion = value,
          validator: (value) {
            if (value.length >= 3) return null;
            return 'Minimo 3 caracteres por favor';
          },
        ),
        SizedBox(height: 20),
        TextFormFieldSample(
          icon: Icon(Icons.alternate_email),
          hintText: 'Email',
          textInputType: TextInputType.emailAddress,
          onSaved: (value) => _usuario.email = value,
          validator: (value) {
            if (utils.isEmail(value)) return null;
            return 'Email es incorrecto';
          },
        ),
        SizedBox(height: 20),
        TextFormFieldSample(
          icon: Icon(Icons.lock),
          hintText: 'Contraseña',
          textInputType: TextInputType.emailAddress,
          validator: (value) {
            if (value.length > 5) return null;
            return 'Minimo 6 caracteres por favor';
          },
          obscureText: _isOcultado,
          suffixIcon: IconButton(
            icon:
                Icon((_isOcultado) ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _isOcultado = !_isOcultado),
          ),
          onSaved: (value) => _usuario.password = value,
        ),
        SizedBox(height: 40),
        BotonGradient(
            onPressed: () => _registrarUsuario(context), titulo: 'GUARDAR'),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () =>
              Navigator.pushReplacementNamed(context, LoginPage.routeName),
          child: Text(
            'Ya tienes cuenta?, ir login',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  double contenidoHeight(BuildContext context) {
    final appBarHeight = AppBar().preferredSize.height;
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    final height = MediaQuery.of(context).size.height;
    final contenidoHeight = height - appBarHeight - statusbarHeight;
    return contenidoHeight;
  }

  void _registrarUsuario(BuildContext context) async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    print(_usuario.toJson());
  }
}
