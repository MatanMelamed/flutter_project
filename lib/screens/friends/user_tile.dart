import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/user_data.dart';

class UserTile extends StatelessWidget{
  UserData user;
  UserTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(user.imageurl),
          ),
          title: Text(user.fullname),
          subtitle: Text(user.gender),
        ),
      ),
    );
  }

}