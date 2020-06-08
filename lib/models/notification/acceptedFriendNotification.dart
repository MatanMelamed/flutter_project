import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/notification/notification.dart' as base;
import 'package:teamapp/screens/userProfile/mainUserProfilePage.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';
import 'package:timeago/timeago.dart' as tAgo;

class AcceptedFriendNotification implements base.Notification {
  String type = "addFriendNotification";
  String _name;
  var metadata = [];

  String _description;
  String _fromID;
  String _imageUrl;
  DocumentSnapshot _docFromOther;
  Timestamp _timestamp;

  AcceptedFriendNotification({this.type, this.metadata});

  @override
  Widget getWidget(context) {
    log("inside getWidget");

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
                      TextSpan(text: "You and "),
                      TextSpan(
                          text: _name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " are now friends")
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
          ),
        ));
  }

  @override
  Future<void> handleMapFromDB(Timestamp timestamp,
      Map<String, dynamic> map) async {
    log("Inside handleMapFromDB");
    log(map.toString());
    _fromID = map['fromID'];
    _docFromOther =
    await Firestore.instance.collection("users").document(_fromID).get();
    _imageUrl = _docFromOther.data['imageUrl'];
    _name = _docFromOther.data['first_name'] + _docFromOther.data['last_name'];
    _description = 'has sent you a friend request';
    _timestamp = timestamp;

    log("exisitmg mapFromDB");
  }
}

//TODO: Differences: Description, Trailing