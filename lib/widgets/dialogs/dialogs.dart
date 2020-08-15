import 'package:flutter/material.dart';
import 'package:teamapp/widgets/meeting/AgeSliderDialog.dart';

class Dialogs {
  static void showTwoButtonsDialog(
      {@required BuildContext context,
      @required MaterialButton firstButton,
      @required MaterialButton secondButton,
      @required Widget title,
      @required Widget content}) {
    AlertDialog dialog = AlertDialog(
      title: title,
      content: content,
      actions: <Widget>[firstButton, secondButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => dialog,
    );
  }

  static showTextInputDialog(BuildContext context, String description) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return TextInputDialog(description);
        });
  }

  static showAgeSlider(BuildContext context, int currentStart, int currentEnd) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AgeSliderDialog(currentStart: currentStart, currentEnd: currentEnd);
        });
  }
}

class TextInputDialog extends StatefulWidget {
  final String inputDescription;

  TextInputDialog(this.inputDescription);

  @override
  _TextInputDialogState createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      child: Container(
        height: 250,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  color: Color(0xff0367b4),
                  boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0.0, 4.0), blurRadius: 2.0)]),
              child: Center(
                child: Text(
                  "Enter a new " + widget.inputDescription,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 18),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: TextField(
                controller: _inputController,
                decoration: InputDecoration(hintText: widget.inputDescription),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop(_inputController.text);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
                SizedBox(width: 50),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop("");
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
