import 'package:flutter/material.dart';

enum MeetingStatus {
  APPROVED,
  ONGOING,
  CANCELED,
}

enum MeetingField {
  MID,
  TID,
  NAME,
  DESCRIPTION,
  STATUS,
  TIME,
  IS_PUBLIC,
  AGE_LIMIT_START,
  AGE_LIMIT_END,
  LOCATION,
  SPORT
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
  int ageLimitStart;
  int ageLimitEnd;

  // not implemented
  String location; // ?
  String sport; // ?

  Meeting.fromDatabase({
    @required this.mid,
    @required this.tid,
    @required this.name,
    @required this.description,
    @required this.status,
    @required this.time,
    @required this.isPublic,
    @required this.ageLimitStart,
    @required this.ageLimitEnd,
    @required this.location,
    @required this.sport,
  });

  Meeting.fromWithinApp({
    @required this.name,
    @required this.description,
    @required this.status,
    @required this.time,
    @required this.isPublic,
    @required this.ageLimitStart,
    @required this.ageLimitEnd,
    @required this.location,
    @required this.sport,
  });

  dynamic propAccess(MeetingField field, {dynamic newValue}) => <MeetingField, dynamic>{
        MeetingField.NAME: () => newValue == null ? this.name : this.name = newValue,
        MeetingField.DESCRIPTION: () => newValue == null ? this.description : this.description = newValue,
        MeetingField.STATUS: () => newValue == null ? this.status : this.status = newValue,
        MeetingField.TIME: () => newValue == null ? this.time : this.time = DateTime.parse(newValue),
        MeetingField.IS_PUBLIC: () => newValue == null ? this.isPublic : this.isPublic = newValue,
        MeetingField.AGE_LIMIT_START: () => newValue == null ? this.ageLimitStart : this.ageLimitStart = newValue,
        MeetingField.AGE_LIMIT_END: () => newValue == null ? this.ageLimitEnd : this.ageLimitEnd = newValue,
        MeetingField.LOCATION: () => newValue == null ? this.location : this.location = newValue,
        MeetingField.SPORT: () => newValue == null ? this.sport : this.sport = newValue,
      }[field]();
}
