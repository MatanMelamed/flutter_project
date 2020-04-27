import 'package:flutter/cupertino.dart';

class Group {
  String gid;
  List<String> membersUids;

  Group.fromDatabase({@required this.gid, @required this.membersUids});

  Group.fromWithinApp({@required this.membersUids});

  Group.addUser(String newUser) {
    membersUids.add(newUser);
  }
}
