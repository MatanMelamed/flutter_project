import 'package:flutter/material.dart';
import 'package:teamapp/models/user.dart';

class TeamUserDialog extends StatefulWidget {
  final User user;
  final bool isAdmin;
  final void Function() viewProfileCallback;
  final void Function() removeUserCallback;

  TeamUserDialog({
                   @required this.user,
                   @required this.isAdmin,
                   this.viewProfileCallback,
                   this.removeUserCallback
                 });

  @override
  _TeamUserDialogState createState() => _TeamUserDialogState();
}

class _TeamUserDialogState extends State<TeamUserDialog> {

  void Function() emptyCallback = () {};

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 15,
      child: Container(
        height: widget.isAdmin ? 290 : 240,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 35, bottom: 15),
                    child: Center(
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(widget.user.remoteImage.url),
                        backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      ),
                    )
                ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                widget.user.firstName + " " + widget.user.lastName,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 18),
                ),
              ),
            Container(
              padding: EdgeInsets.only(bottom: 10),
              width: 160,
              child: RaisedButton(
                elevation: 10,
                onPressed: widget.viewProfileCallback ?? emptyCallback,
                child: Text(
                  "View Profile",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                color: Colors.blue,
                ),
              ),
            widget.isAdmin
                ? Container(
              padding: EdgeInsets.only(bottom: 10),
              width: 160,
              child: RaisedButton(
                  elevation: 10,
                  onPressed: widget.removeUserCallback ?? emptyCallback,
                  child: Center(
                    child: Text(
                      "Remove user",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  color: Colors.white,
                  shape: Border.all(color: Colors.blue)),
              )
                : SizedBox(width: 0, height: 0)
          ],
          ),
        ),
      );
  }
}
