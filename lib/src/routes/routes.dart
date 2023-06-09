import 'package:flutter/material.dart';
import 'package:quickbread/src/pages/about_page.dart';
import 'package:quickbread/src/pages/ayuda_page.dart';
import 'package:quickbread/src/pages/cuando_page.dart';
import 'package:quickbread/src/pages/home_page.dart';
import 'package:quickbread/src/pages/login_page.dart';
import 'package:quickbread/src/pages/pedido_create_page.dart';
import 'package:quickbread/src/pages/pedido_detalle_page.dart';
import 'package:quickbread/src/pages/pedido_detalle_admin_page.dart';
import 'package:quickbread/src/pages/pedido_admin_page.dart';
import 'package:quickbread/src/pages/pedido_resumen_page.dart';
import 'package:quickbread/src/pages/pedido_ubicacion.dart';
import 'package:quickbread/src/pages/perfil_page.dart';
import 'package:quickbread/src/pages/producto_detalle_page.dart';
import 'package:quickbread/src/pages/producto_page.dart';
import 'package:quickbread/src/pages/registro_page.dart';
import 'package:quickbread/src/pages/search_page.dart';
import 'package:quickbread/src/pages/yo_edit_page.dart';
import 'package:quickbread/src/pages/sucursal_info_page.dart';

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
  PedidoAdminPage.routeName: (BuildContext context) => PedidoAdminPage(),
  PedidoNuevoDetallePage.routeName: (BuildContext context) =>
      PedidoNuevoDetallePage(),
  AboutPage.routeName: (BuildContext context) => AboutPage(),
  CuandoPage.routeName: (BuildContext context) => CuandoPage(),
  SearchPage.routeName: (_) => SearchPage(),
  YoEditPage.routeName: (_) => YoEditPage(),
  SucursalInfoPage.routeName: (_) => SucursalInfoPage(),
};
