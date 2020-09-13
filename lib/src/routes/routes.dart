import 'package:flutter/material.dart';
import 'package:quickbread/src/pages/about_page.dart';
import 'package:quickbread/src/pages/ayuda_page.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/pages/login_page.dart';
import 'package:quickbread/src/pages/pedido_create_page.dart';
import 'package:quickbread/src/pages/pedido_detalle_page.dart';
import 'package:quickbread/src/pages/pedido_nuevo_detalle_page.dart';
import 'package:quickbread/src/pages/pedido_nuevos_.page.dart';
import 'package:quickbread/src/pages/pedido_resumen_page.dart';
import 'package:quickbread/src/pages/pedido_ubicacion.dart';
import 'package:quickbread/src/pages/perfil_page.dart';
import 'package:quickbread/src/pages/producto_detalle_page.dart';
import 'package:quickbread/src/pages/producto_page.dart';
import 'package:quickbread/src/pages/registro_page.dart';

final Map<String, WidgetBuilder> routes = {
  HomePage.routeName: (BuildContext context) => HomePage(),
  ProductoPage.routeName: (BuildContext context) => ProductoPage(),
  ProductoDetallePage.routeName: (BuildContext context) =>
      ProductoDetallePage(),
  PedidoResumenPage.routeName: (BuildContext context) => PedidoResumenPage(),
  PedidoCreatePage.routeName: (BuildContext context) => PedidoCreatePage(),
  LoginPage.routeName: (BuildContext context) => LoginPage(),
  RegistroPage.routeName: (_) => RegistroPage(),
  PerfilPage.routeName: (_) => PerfilPage(),
  AyudaPage.routeName: (BuildContext context) => AyudaPage(),
  PedidoUbicacion.routeName: (BuildContext context) => PedidoUbicacion(),
  PedidoDetallePage.routeName: (BuildContext context) => PedidoDetallePage(),
  PedidoNuevoPage.routeName: (BuildContext context) => PedidoNuevoPage(),
  PedidoNuevoDetallePage.routeName: (BuildContext context) =>
      PedidoNuevoDetallePage(),
  AboutPage.routeName: (BuildContext context) => AboutPage(),
};
