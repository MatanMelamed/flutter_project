import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final void Function(String) onChanged;
  final bool discreet;

  CustomTextField(
      {this.hintText = "",
        this.discreet = false,
        this.inputType = TextInputType.text,
        @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: this.discreet,
      obscureText: this.discreet,
      onChanged: this.onChanged,
      keyboardType: this.inputType,
      decoration: InputDecoration(
        hintText: this.hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}