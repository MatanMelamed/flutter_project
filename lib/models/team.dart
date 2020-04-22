import 'package:flutter/material.dart';
import 'package:teamapp/models/user.dart';

class Team {
  String tid;
  String name;
  String description;
  bool isPrivate;
  //User owner;
  String image;

  Team({String tid, String name, String description, bool isPrivate, User owner, String groupID, Image image}){
    this.tid = tid ?? "no tid";
    this.name = name ?? "no name";
    this.description = description ?? "no description";
    this.isPrivate = isPrivate ?? false;
    this.image = image ?? defaultImage();
  }

  static defaultImage() {
    //return "assets/images/team.jpg";
    return "assets/images/default_profile_img.png";
  }

  static Team getBasicExample() {
    return Team(
        tid: "007",
        name: "TeamApp",
        description: "Best team ever.",
        isPrivate: false,
        //owner: User.getBasicExample(),
        groupID: "002");
  }
}
