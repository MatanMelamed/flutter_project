import 'package:flutter/material.dart';
import 'package:teamapp/models/meeting.dart';
import 'package:teamapp/services/firestore/meetingDataManager.dart';
import 'package:teamapp/widgets/loading.dart';
import 'package:teamapp/widgets/meeting/meeting_card.dart';

class MeetingSearchResults extends StatefulWidget {
  final check = MeetingDataManager.check("d2pe9OlwAWmhmaBF77sV");

  @override
  _MeetingSearchResultsState createState() => _MeetingSearchResultsState();
}

class _MeetingSearchResultsState extends State<MeetingSearchResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Meeting>>(
        future: widget.check,
        builder: (context, meetingsSnapshot) {
          var meetings = meetingsSnapshot.data;

          return meetingsSnapshot.hasData
              ? ListView.builder(
                  itemCount: meetings.length,
                  itemBuilder: (context, i) {
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: MeetingCard(
                        meeting: meetings[i],
                      ),
                    );
                  },
                )
              : Loading();
        },
      ),
    );
  }
}
