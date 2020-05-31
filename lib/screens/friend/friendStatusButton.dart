import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/services/firestore/friendDataManaget.dart';
import 'package:teamapp/widgets/loading.dart';

class FriendStatusButton extends StatefulWidget {
  final User otherUser;

  FriendStatusButton({this.otherUser});

  @override
  State<StatefulWidget> createState() => _FriendStatusButtonState();
}

class _FriendStatusButtonState extends State<FriendStatusButton> {
  FriendDataManager _friendDataManager;
  String _status;
  bool loading = false;

  Future<String> createDataBase(User currentOnlineUser) async {
    _friendDataManager = FriendDataManager(
        userId: currentOnlineUser.uid, otherId: widget.otherUser.uid);
    _status = await _friendDataManager.getStatus();
    return _status;
  }


  Widget abstractButton(String text, var functionOnClick, IconData icon) {
    return RaisedButton.icon(
      icon: Icon(icon),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      onPressed: () async {
        setState(() {
          loading = true;
        });
        functionOnClick();
        _status = await _friendDataManager.getStatus().then((value) => value);
        setState(() {
          loading = false;
        });
      },
      color: Colors.blue.withOpacity(0.97),
      label: Text(
        text,
        style: TextStyle(
            color: Colors.white,
            letterSpacing: 0.3,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
            fontSize: 16),
      ),
    );
  }

  Widget buildNotTheSameUser(User currentOnlineUser, String _status){
    createDataBase(currentOnlineUser);
    if (_status == "no_friend")
      return abstractButton(
          "  Add friend  ", _friendDataManager.sendFriendRequest, Icons.person_add);
    else if (_status == "friend")
      return abstractButton(
           "  Un Friend  ", _friendDataManager.unFriend, Icons.cancel);
    else if (_status == "send")
      return abstractButton("  Cancel Request  ", _friendDataManager.cancelRequest, Icons.cancel);
    else if (_status == "request")
      return
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              abstractButton("  Accept  ", _friendDataManager.acceptFriend, Icons.person_add),
              SizedBox(width: 20.0,),
              abstractButton("  Rejected  ", _friendDataManager.cancelRequest, Icons.cancel),
            ],
          );

  }

  @override
  Widget build(BuildContext context) {
    var currentOnlineUser = Provider.of<User>(context);
    if (currentOnlineUser.uid != widget.otherUser.uid) {
      return FutureBuilder<String>(
        future: createDataBase(currentOnlineUser),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return loading ? Loading() : buildNotTheSameUser(currentOnlineUser, snapshot.data);
          } else {
            return Loading();
          }
        },
      );

    }
    return SizedBox();
  }
}
