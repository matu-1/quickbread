import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickbread/src/constants/common_text.dart';
import 'package:quickbread/src/constants/path.dart';
import 'package:quickbread/src/models/usuario_model.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/pages/pedido_create_page.dart';
import 'package:quickbread/src/pages/registro_page.dart';
import 'package:quickbread/src/providers/usuario_provider.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    pr = new ProgressDialog(context, isDismissible: false);
    pr.style(message: CommonText.loading);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          child: Image(height: 150, width: 150, image: AssetImage(logoPath)),
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
              icon:
                  Icon((_isOcultado) ? Icons.visibility : Icons.visibility_off),
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
    final _isResumenPage = ModalRoute.of(context).settings.arguments;
    formKey.currentState.save();
    final _usuarioProvider = new UsuarioProvider();
    pr.show();
    try {
      await _usuarioProvider.login(usuario);
      pr.hide();
      if (_isResumenPage != null)
        Navigator.of(context).pushReplacementNamed(PedidoCreatePage.routeName);
      else
        Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeName, (Route route) => false);
    } catch (e) {
      pr.hide();
      utils.showSnackbar(e.message, _scaffoldKey);
    }
  }
}
