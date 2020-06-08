import 'package:flutter/cupertino.dart';

class UsersList {
  String ulid;
  List<String> membersUids;

  // each user can have metadata in the form of a map from value name to value,
  // for example user may have metadata of { 'status' : <bool type>, 'name': <string type>, ...}
  Map<String, Map<String, dynamic>> metadata;

  UsersList.fromDatabase({
    @required this.ulid,
    @required this.membersUids,
    @required this.metadata,
  });

  UsersList.fromWithinApp({@required this.membersUids, this.metadata}) {
    // create empty metadata for all users if none received.
    if (metadata == null) {
      metadata = {};
      for (String uid in membersUids) {
        metadata[uid] = {};
      }
    }
  }

  UsersList.addUser(String uid, {Map<String, dynamic> metadata}) {
    membersUids.add(uid);
    metadata[uid] = metadata;
  }
}
