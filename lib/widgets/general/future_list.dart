import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/meeting.dart';
import 'package:teamapp/services/firestore/meetingDataManager.dart';
import 'package:teamapp/widgets/loading.dart';
import 'package:teamapp/widgets/meeting/meeting_card.dart';

class FutureList extends StatefulWidget {
  int km;
  GeoPoint useLocation;
  DateTime startDate;
  DateTime endDate;
  String sportType;
  String title;

  FutureList(
      this.km, this.useLocation, this.startDate, this.endDate, this.sportType, this.title);

  @override
  _FutureListState createState() => _FutureListState();
}

class _FutureListState extends State<FutureList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Meeting>>(
        future: MeetingDataManager.searchMeeting(widget.km, widget.useLocation,
            widget.startDate, widget.endDate, widget.sportType),
        builder: (context, AsyncSnapshot<List<Meeting>> meetingsSnapshot) {
          if (meetingsSnapshot.connectionState != ConnectionState.done) {
            return Loading();
          }
          if (meetingsSnapshot.hasError) {
            print("error");
          }
          List<Meeting> meetings = meetingsSnapshot.data;
          print(meetings.length);
          return ListView.builder(
            itemCount: meetings.length,
            itemBuilder: (context, i) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: MeetingCard(
                  meeting: meetings[i],
                  userLocation: widget.useLocation,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

