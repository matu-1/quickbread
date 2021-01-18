import 'package:flutter/material.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/icons/my_icon_icons.dart';

class ErrorCustom extends StatelessWidget {
  final String message;
  ErrorCustom({@required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(paddingUI),
        margin: EdgeInsets.only(bottom: 40),
        // color: Colors.red,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              MyIcon.carritatriste,
              size: 100,
            ),
            Text(
              this.message,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
