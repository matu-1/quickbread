import 'package:flutter/material.dart';

class ChipCustom extends StatelessWidget {
  final String value;
  final Color color;
  ChipCustom({@required this.value, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        value,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
