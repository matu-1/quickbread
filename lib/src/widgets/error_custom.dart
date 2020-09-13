import 'package:flutter/material.dart';
import 'package:quickbread/src/icons/my_icon_icons.dart';

class ErrorCustom extends StatelessWidget {
  final String message;
  ErrorCustom({@required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            MyIcon.carritatriste,
            size: 120,
          ),
          Text(
            this.message,
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
