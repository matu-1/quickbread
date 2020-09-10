import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickbread/src/models/usuario_model.dart';
import 'package:quickbread/src/pages/registro_page.dart';
import 'package:quickbread/src/utils/utils.dart' as utils;
import 'package:quickbread/src/widgets/TextFormFieldSample.dart';
import 'package:quickbread/src/widgets/boton_gradient.dart';

class LoginPage extends StatefulWidget {
  static final routeName = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  UsuarioModel usuario = new UsuarioModel();
  ProgressDialog pr;
  bool _isOcultado = true;

  @override
  void initState() {
    pr = new ProgressDialog(context, isDismissible: false);
    pr.style(message: 'Espere por favor');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              _logoContainer(context),
              _formContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoContainer(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.44,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 22),
        child: Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Image(
              height: 200,
              width: 200,
              image: AssetImage('assets/images/icon3.png')),
        ),
      ),
    );
  }

  Widget _formContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: <Widget>[
          TextFormFieldSample(
            icon: Icon(Icons.person),
            hintText: 'Email',
            textInputType: TextInputType.emailAddress,
            onSaved: (value) => usuario.email = value,
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
              icon: Icon(
                  (_isOcultado) ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _isOcultado = !_isOcultado),
            ),
            onSaved: (value) => usuario.password = value,
          ),
          SizedBox(height: 40),
          BotonGradient(onPressed: () => _login(context), titulo: 'INGRESAR'),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () =>
                Navigator.pushReplacementNamed(context, RegistroPage.routeName),
            child: Text(
              'No tienes cuenta?, crea una aqui',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  _login(BuildContext context) async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    print(usuario.toJson());
  }
}

