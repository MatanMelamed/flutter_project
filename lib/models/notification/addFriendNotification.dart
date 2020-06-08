import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/notification/notification.dart' as base;
import 'package:teamapp/screens/userProfile/mainUserProfilePage.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';
import 'package:timeago/timeago.dart' as tAgo;

class AddFriendNotification implements base.Notification {
  String type = "addFriendNotification";
  String _name;
  var metadata = [];

  String _description;
  String _fromID;
  String _imageUrl;
  DocumentSnapshot _docFromOther;
  Timestamp _timestamp;
  AddFriendNotification({this.type, this.metadata});

  @override
  Widget getWidget(context) {

    return Padding(
        padding: EdgeInsets.only(bottom: 2.0),
        child: Container(
          color: Colors.white,
          child: ListTile(
            title: GestureDetector(
              onTap: () {
                var userProfile =
                    UserDataManager.createUserFromDoc(_docFromOther);
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MainUserProfilePage(user: userProfile)));
              },
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(
                          text: _name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " has send you a friend request")
                    ]),
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(_imageUrl),
            ),
            subtitle: Text(
              tAgo.format(_timestamp.toDate()),
              overflow: TextOverflow.ellipsis,
            ),
//            trailing: acceptOrReject(),
          ),
        ));
  }

  @override
  Future<void> handleMapFromDB(
      Timestamp timestamp, Map<String, dynamic> map) async {
    _fromID = map['fromID'];
    _docFromOther =
        await Firestore.instance.collection("users").document(_fromID).get();
    _imageUrl = _docFromOther.data['imageUrl'];
    _name = _docFromOther.data['first_name'] + _docFromOther.data['last_name'];
    _description = 'has sent you a friend request';
    _timestamp = timestamp;

  }

//
//  Widget acceptOrReject() {
//    return
//      Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          // will delete the requests delete the requests and notifications \
//          // and will create friendship with new notifications
//          abstractButton(
//              "  Accept  ", _friendDataManager.acceptFriend, Icons.person_add),
//          SizedBox(width: 20.0,),
//          abstractButton(
//              "  Rejected  ", _friendDataManager.cancelRequest, Icons.cancel),
//        ],
//      );
//  }

}

//
//return Padding(
//padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
//child: InkWell(
//onTap: () {
//var userProfile = UserDataManager.createUserFromDoc(_docFromOther);
//Navigator.of(context).push(MaterialPageRoute(
//builder: (context) => MainUserProfilePage(user: userProfile)));
//},
//child: Row(
//mainAxisAlignment: MainAxisAlignment.start,
//children: <Widget>[
//Hero(
//tag: _imageUrl,
//child: CircleAvatar(
//backgroundImage: NetworkImage(_imageUrl),
//radius: 30.0,
//),
//),
//SizedBox(
//width: 10.0,
//),
//RichText(
//text: TextSpan(
//text: _name,
//style: TextStyle(
//color: Colors.black,
//fontFamily: 'Montserrat',
//fontSize: 17.0,
//fontWeight: FontWeight.bold),
//children: [
//TextSpan(
//text: _description,
//style: TextStyle(
//fontFamily: 'Montserrat',
//fontSize: 17.0,
//fontWeight: FontWeight.normal),
//)
//]),
//)
//],
//),
//),
//);
