import 'package:flutter/material.dart';

class JoinDialog extends StatefulWidget {
  final String title;
  final String description;
  final void Function() confirmCallback;
  final void Function() cancelCallback;

  JoinDialog(
      {@required this.title,
        @required this.description,
        this.cancelCallback,
        this.confirmCallback,
});

  @override
  _JoinDialogState createState() => _JoinDialogState();
}

class _JoinDialogState extends State<JoinDialog> {
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
            Container(
              child: Text(
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
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
                          "Join",
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
                          "Cancel",
                          style: TextStyle(color: Colors.blue[900], fontSize: 16),
                        ),
                        color: Colors.white,
                        shape: Border.all(color: Colors.blue[900]),
                      ),
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
//
//
//void _leaveTeam() async {
//  bool shouldRemove = await showDialog(
//      context: context,
//      builder: (ctx) => GeneralAlertDialog(
//        title: 'Alert',
//        content: "Are you sure you want to leave ${team.name}?",
//        confirmCallback: () {
//          Navigator.of(context).pop(true);
//        },
//        cancelCallback: () {
//          Navigator.of(context).pop(false);
//        },
//      ));
//
//  if (shouldRemove) {
//    setState(() => isLoading = true);
//    if (isAdmin) {
//      if (users.length > 1) {
//        for (User user in users) {
//          if (user.uid == currentUser.uid) {
//            continue;
//          }
//          print('${user.uid} and ${currentUser.uid}');
//          await TeamDataManager.updateTeamField(team, TeamField.OWNER_UID, user.uid);
//        }
//      } else {
//        // delete team
//      }
//    }
//    await TeamDataManager.removeUserFromTeam(team, newUser: currentUser);
//    Navigator.of(context).pop(true);
//  }
//}
//
//void _removeUser(User user) async {
//  bool shouldRemove = await showDialog(
//      context: context,
//      builder: (ctx) => GeneralAlertDialog(
//        title: 'Alert',
//        content: "Are you sure you want to remove " +
//            user.firstName +
//            " " +
//            user.lastName +
//            " from " +
//            team.name +
//            "?",
//        confirmCallback: () {
//          Navigator.of(context).pop(true);
//        },
//        cancelCallback: () {
//          Navigator.of(context).pop(false);
//        },
//      ));
//
//  if (shouldRemove) {
//    TeamDataManager.removeUserFromTeam(team, newUser: user);
//    reloadWidget();
//    Navigator.of(context).pop();
//  }
//}
//}
