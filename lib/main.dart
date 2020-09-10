import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/routes/routes.dart';
import 'package:quickbread/src/theme/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PedidoModel(detalles: []),
      child: MaterialApp(
        title: 'Quick Bread app',
        debugShowCheckedModeBanner: false,
        initialRoute: HomePage.routeName,
        routes: routes,
        theme: theme,
      ),
    );
  }
}
