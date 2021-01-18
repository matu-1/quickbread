import 'package:flutter/material.dart';
import 'package:quickbread/src/constants/path.dart';
import 'package:quickbread/src/constants/ui.dart';

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
          padding: EdgeInsets.all(paddingUI),
          child: Column(
            children: <Widget>[
              Image(height: 150, width: 150, image: AssetImage(logoPath)),
              Text('Version: 1.3.0'),
              SizedBox(
                height: 30,
              ),
              Text(
                'Quickbread es una aplicación para realizar pedidos de panes lo que facilita al consumidor tener lo que quiere sin necesidad de ir a comprarlo personalmente.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Eliges lo que te gusta, agregas los datos de tu ubicación y tu pedido va por ti.',
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
