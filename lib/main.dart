import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/routes/routes.dart';
import 'package:quickbread/src/share_prefs/preferencias_usuario.dart';
import 'package:quickbread/src/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PedidoModel(detalles: []),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Quick Bread app',
        debugShowCheckedModeBanner: false,
        initialRoute: _prefs.paginaInicio(),
        routes: routes,
        theme: theme,
      ),
    );
  }
}
