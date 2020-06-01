import 'package:flutter/material.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';

class Message extends StatefulWidget {
  final String userID;
  final String message;
  final String timestamp;
  final bool me;

  Message({this.userID, this.message, this.timestamp, this.me});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  Future<String> _userName;

  Future<String> _getUserName() async {
    var user = await UserDataManager.getUser(widget.userID);
    return "${user.firstName} ${user.lastName}";
  }

  @override
  void initState() {
    super.initState();
    if (_userName == null) _userName = this._getUserName();
  }

  Widget _fBuild(BuildContext context, AsyncSnapshot<String> snapshot) {
    var me = widget.me;
    var message = widget.message;

    return snapshot.hasData
        ? Container(
            margin: EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment:
                  me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(snapshot.data),
                SizedBox(
                  height: 5.0,
                ),
                Material(
                  color: me ? Colors.lightBlue : Colors.green,
                  borderRadius: BorderRadius.circular(50.0),
                  elevation: 6.0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Text(message),
                  ),
                ),
              ],
            ),
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: this._userName,
      builder: _fBuild,
    );
  }
}
