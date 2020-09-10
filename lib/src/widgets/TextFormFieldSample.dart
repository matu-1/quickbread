import 'package:flutter/material.dart';

class TextFormFieldSample extends StatelessWidget {
  final String hintText;
  final Function(String) validator;
  final Function(String) onSaved;
  final Icon icon;
  final TextInputType textInputType;
  final bool obscureText;
  final Widget suffixIcon;
  final TextCapitalization textCapitalization;

  TextFormFieldSample({
    Key key,
    @required this.hintText,
    @required this.validator,
    @required this.onSaved,
    @required this.icon,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: textCapitalization,
      style: TextStyle(color: Theme.of(context).primaryColor),
      obscureText: this.obscureText,
      keyboardType: textInputType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        hintText: this.hintText,
        prefixIcon: this.icon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
