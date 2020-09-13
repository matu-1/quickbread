import 'package:flutter/material.dart';

class TextProp extends StatelessWidget {
  final styleSubtitulo = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.5,
      color: Colors.black);
  final styleTexto =
      TextStyle(height: 1.5, fontSize: 14, fontWeight: FontWeight.normal);
  final String prop;
  final String text;
  TextProp({@required this.prop, @required this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: '$prop ',
          style: styleSubtitulo,
          children: [TextSpan(text: text, style: styleTexto)]),
    );
  }
}
