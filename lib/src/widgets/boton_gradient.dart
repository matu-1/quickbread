import 'package:flutter/material.dart';

class BotonGradient extends StatelessWidget {
  final Function onPressed;
  final String titulo;
  final double paddingVertical;

  BotonGradient(
      {@required this.onPressed,
      @required this.titulo,
      this.paddingVertical = 15.0});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.zero,
      shape: StadiumBorder(),
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
            gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ])),
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: this.paddingVertical),
            width: double.infinity,
            child: Text(this.titulo)),
      ),
      textColor: Colors.white,
      onPressed: this.onPressed,
    );
  }
}
