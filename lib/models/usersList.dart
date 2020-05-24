import 'package:flutter/cupertino.dart';

class UsersList {
  String ulid;
  List<String> membersUids;

  UsersList.fromDatabase({@required this.ulid, @required this.membersUids});

  UsersList.fromWithinApp({@required this.membersUids});

  UsersList.addUser(String newUser) {
    membersUids.add(newUser);
  }
}
