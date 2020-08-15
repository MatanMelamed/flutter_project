import 'package:flutter/material.dart';
import 'package:teamapp/widgets/meeting/AgeRangeSlider.dart';

class AgeSliderDialog extends StatefulWidget {
  final int currentStart;
  final int currentEnd;

  AgeSliderDialog({
    @required this.currentStart,
    @required this.currentEnd,
  });

  @override
  _AgeSliderDialogState createState() => _AgeSliderDialogState();
}

class _AgeSliderDialogState extends State<AgeSliderDialog> {
  List<int> values = [];

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
                  "Select age range",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 18),
                ),
              ),
            ),
            AgeRangeSliders(
              currentStart: widget.currentStart,
              currentEnd: widget.currentEnd,
              callback: (a, b) {
                values.clear();
                values.add(a);
                values.add(b);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop(values);
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
                    Navigator.of(context).pop();
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
