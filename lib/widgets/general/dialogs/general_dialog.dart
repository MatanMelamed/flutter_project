import 'package:flutter/material.dart';

class GeneralDialog extends StatefulWidget {
  final String title;
  final Widget content;
  final String confirmText;
  final String cancelText;
  final void Function() confirmCallback;
  final void Function() cancelCallback;

  GeneralDialog(
      {@required this.title,
        @required this.content,
        this.cancelCallback,
        this.confirmCallback,
        this.confirmText,
        this.cancelText});

  @override
  _GeneralDialogState createState() => _GeneralDialogState();
}

class _GeneralDialogState extends State<GeneralDialog> {
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
                color: Colors.blue[600],
                boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0.0, 4.0), blurRadius: 2.0)],
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
            Center(
              child: widget.content,
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
                          widget.confirmText ?? "Confirm",
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
                          onPressed: widget.cancelCallback ?? emptyCallback,
                          child: Text(
                            widget.cancelText ?? "Cancel",
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
