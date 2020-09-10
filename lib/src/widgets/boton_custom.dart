import 'package:flutter/material.dart';

class BotonCustom extends StatelessWidget {
  final String titulo;
  final Function onPressed;
  final bool outline;
  final double elevation;
  BotonCustom(
      {@required this.titulo, @required this.onPressed, this.outline = false, this.elevation = 2});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      elevation: elevation,
      color: outline ? Colors.white : Theme.of(context).primaryColor,
      textColor: outline ? Theme.of(context).primaryColor : Colors.white,
      shape: !outline
          ? StadiumBorder()
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side:
                  BorderSide(width: 1, color: Theme.of(context).primaryColor)),
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Text(titulo),
      ),
    );
  }
}
