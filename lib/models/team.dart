import 'package:flutter/cupertino.dart';
import 'package:teamapp/models/storageImage.dart';

class Team {
  // generated by firestore saving process
  String tid;
  StorageImage remoteStorageImage;
  String ulid; //user list id

  // given by the user
  String name;
  String description;
  bool isPublic;
  String ownerUid;

  Team.fromDatabase({
    @required this.tid,
    @required this.remoteStorageImage,
    @required this.ulid,
    @required this.name,
    @required this.description,
    @required this.isPublic,
    @required this.ownerUid,
  });

  Team.fromWithinApp({
    @required this.name,
    @required this.description,
    @required this.isPublic,
    @required this.ownerUid,
  });

  void setUserListID(String ulid) {
    this.ulid = ulid;
  }
}
