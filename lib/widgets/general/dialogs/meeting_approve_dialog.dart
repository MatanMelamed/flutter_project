import 'package:flutter/material.dart';

class MeetingApproveDialog extends StatefulWidget {
  final bool firstValue;

  MeetingApproveDialog({@required this.firstValue});

  @override
  _MeetingApproveDialogState createState() => _MeetingApproveDialogState();
}

class _MeetingApproveDialogState extends State<MeetingApproveDialog> {
  bool val = false;
  void Function() emptyCallback = () {};

  @override
  void initState() {
    super.initState();
    val = widget.firstValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 15,
      child: Container(
        color: Colors.black12,
        child: Wrap(
          runSpacing: 30,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[600],
                boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0.0, 4.0), blurRadius: 2.0)],
              ),
              height: 50,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Change Arrival Status',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Center(
              child: Tooltip(
                message: "Arrival status",
                child: Container(
                  padding: EdgeInsets.only(bottom: 25),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "I am going to arrive to this meeting!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                      Switch(
                        value: val,
                        onChanged: (newVal) {
                          val = !val;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      width: 180,
                      child: RaisedButton(
                        elevation: 10,
                        onPressed: () {
                          Navigator.of(context).pop(val);
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        color: Colors.blue[900],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 30),
                      width: 180,
                      child: RaisedButton(
                          elevation: 10,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.blue[900], fontSize: 16),
                          ),
                          color: Colors.white,
                          shape: Border.all(color: Colors.blue[900])),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
