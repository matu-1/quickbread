import 'package:flutter/material.dart';
import 'package:quickbread/src/constants/pages.dart';

class AboutPage extends StatelessWidget {
  static final routeName = 'about';
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: <Widget>[
              Image(
                  height: 170,
                  width: 170,
                  image: AssetImage('assets/images/logo.png')),
              Text('Version: 1.0.0'),
              SizedBox(
                height: 30,
              ),
              Text(
                'Pan Integral es una aplicacion para realizar pedidos de panes lo que facilita al consumidor tener lo que quiere sin necesidad de ir a comprarlo personalmente.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Eliges lo que te gusta, agregas los datos de tu ubicacion y tu pedido va por ti.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Desarrollado por M.M.F.R.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
