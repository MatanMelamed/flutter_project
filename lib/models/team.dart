import 'package:flutter/material.dart';
import 'package:teamapp/models/user.dart';

class Team {
  String uid;
  String name;
  String description;
  String groupID;
  bool isPrivate;
  User owner;
  Image image;

  Team({String uid, String name, String description, bool isPrivate, User owner, String groupID, Image image})
      : this.image = image ?? defaultImage() {}

  static defaultImage() {
    return Image.asset("assets/images/team.jpg");
  }

  static Team getBasicExample() {
    return Team(
        uid: "007",
        name: "TeamApp",
        description: "Best team ever.",
        isPrivate: false,
        owner: User.getBasicExample(),
        groupID: "002");
  }
}
