import 'package:flutter/material.dart';
import 'package:teamapp/models/storageImage.dart';

class User {
  String email;
  String uid;
  StorageImage remoteImage;
  String firstName;
  String lastName;
  String gender;
  DateTime birthday;

  User.fromDatabase(
      {@required this.email,
      @required this.uid,
      @required this.remoteImage,
      @required this.firstName,
      @required this.lastName,
      @required this.gender,
      @required this.birthday});


  User.fromWithinApp(
      {@required this.email,
      @required this.uid,
      @required this.firstName,
      @required this.lastName,
      @required this.gender,
      @required this.birthday});
}
