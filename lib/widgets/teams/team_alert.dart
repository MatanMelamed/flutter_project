import 'package:flutter/material.dart';

class TeamAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final void Function() confirmCallback;
  final void Function() cancelCallback;

  TeamAlertDialog(
      {@required this.title,
      @required this.content,
      this.cancelCallback,
      this.confirmCallback});

  @override
  _TeamAlertDialogState createState() => _TeamAlertDialogState();
}

class _TeamAlertDialogState extends State<TeamAlertDialog> {
  void Function() emptyCallback = () {};

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
                color: Colors.red[600],
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 4.0),
                      blurRadius: 2.0)
                ],
              ),
              height: 50,
              width: double.infinity,
              child: Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              child: Text(
                widget.content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
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
                        onPressed: widget.confirmCallback ?? emptyCallback,
                        child: Text(
                          "Remove",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        color: Colors.red[900],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 30),
                      width: 180,
                      child: RaisedButton(
                          elevation: 10,
                          onPressed: widget.cancelCallback ?? emptyCallback,
                          child: Text(
                            "Cancel",
                            style:
                                TextStyle(color: Colors.red[900], fontSize: 16),
                          ),
                          color: Colors.white,
                          shape: Border.all(color: Colors.red[900])),
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

/*
Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    elevation: 10,
                    onPressed: widget.confirmCallback ?? emptyCallback,
                    child: Text(
                      "Remove",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    color: Colors.red[900],
                    ),
                  SizedBox(width: 35),
                  RaisedButton(
                      elevation: 10,
                      onPressed: widget.cancelCallback ?? emptyCallback,
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red[900], fontSize: 16),
                          ),
                        ),
                      color: Colors.white,
                      shape: Border.all(color: Colors.red[900]))
                ],
                ),
 */
