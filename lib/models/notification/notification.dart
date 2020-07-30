import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
//enum Type {
//  addFriendNotification,
//  acceptedFriendNotification,
//}

class Notification {
  String type;
  var metadata;

  Notification({this.type,this.metadata});

  Widget getWidget(context) {}

  Future<void> handleMapFromDB(Timestamp timestamp, Map<String,dynamic> map) {}

//  UsersList.fromWithinApp({@required this.membersUids});
//
//  UsersList.addUser(String newUser) {
//    membersUids.add(newUser);
//  }
}
