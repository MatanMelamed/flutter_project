import 'package:flutter/material.dart';

class User {
  String uid;
  String first_name;
  String last_name;
  Image image;

  User({String uid, String first_name, String last_name, Image image}) : this.image = image ?? defaultImage() {}

  static defaultImage() {
    return Image.asset("assets/images/default_profile_img.png");
  }

  static getBasicExample(){
    return User(uid: "007",first_name: "Matan",last_name: "Melamed");
  }
}
