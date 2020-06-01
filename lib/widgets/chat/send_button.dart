import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback onSend;
  final Color color;

  SendButton({
    @required this.onSend,
    this.text = "Send",
    this.color = Colors.blueGrey,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: FlatButton(
        color: this.color,
        onPressed: this.onSend,
        child: Text(this.text),
      ),
    );
  }
}