import 'package:flutter/material.dart';

class BotonCustom extends StatelessWidget {
  final String titulo;
  final Function onPressed;
  BotonCustom({@required this.titulo, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      shape: StadiumBorder(),
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(titulo),
      ),
    );
  }
}
