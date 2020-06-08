import 'package:flutter/material.dart';
import 'package:teamapp/models/usersList.dart';

enum MeetingStatus{
  APPROVED,
  ONGOING,
  CANCELED,
}

class Meeting {
  // generated by firestore saving process
  String mid;
  String tid;

  // given by the user
  String name;
  String description;
  MeetingStatus status;
  DateTime time;
  bool isPublic;
  UsersList arrivalConfirms;
  int ageLimitStart;
  int ageLimitEnd;

  // not implemented
  String location;  // ?
  String sport;     // ?

  Meeting.fromDatabase(
      {@required this.mid,
        @required this.tid,
        @required this.name,
        @required this.description,
        @required this.status,
        @required this.time,
        @required this.isPublic,
        @required this.arrivalConfirms,
        @required this.ageLimitStart,
        @required this.ageLimitEnd,
        @required this.location,
        @required this.sport,
      });


  Meeting.fromWithinApp(
      {@required this.name,
        @required this.description,
        @required this.status,
        @required this.time,
        @required this.isPublic,
        @required this.arrivalConfirms,
        @required this.ageLimitStart,
        @required this.ageLimitEnd,
        @required this.location,
        @required this.sport,
      });
}