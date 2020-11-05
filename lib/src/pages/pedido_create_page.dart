import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/constants/common_page.dart';
import 'package:quickbread/src/constants/tipo_entregas.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/models/tipo_entrega_model.dart';
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
  final formKey = GlobalKey<FormState>();
  final styleTitulo =
      TextStyle(fontSize: sizeSubtituloUI, fontWeight: FontWeight.w600);
  PedidoModel _pedido;
  final _pedidoProvider = new PedidoProvider();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog _pr;
  PreferenciasUsuario _prefs = new PreferenciasUsuario();
  TipoEntregaModel _tipo = tipoEntregas[0];

  @override
  void didChangeDependencies() {
    _pedido = Provider.of<PedidoModel>(context);
    _pedido.tipoEntregId = _tipo.id;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _pr = new ProgressDialog(context, isDismissible: false);
    _pr.style(message: loadingC);

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
          Text(_tipo.nombre),
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
                  ...tipoEntregas.map(
                    (tipo) => GestureDetector(
                      onTap: () {
                        setState(() => _tipo = tipo);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.all(paddingUI),
                        child: Text(
                          tipo.nombre,
                          style: styleTitulo,
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  void _registrarPedido() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    _pr.show();
    try {
      await _pedidoProvider.create(_pedido);
      _pr.hide();
      Provider.of<PedidoModel>(context, listen: false).reset();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
    } catch (e) {
      showSnackbar(e.message, _scaffoldKey);
      Future.delayed(Duration(milliseconds: 200), () => _pr.hide());
    }
  }
}
