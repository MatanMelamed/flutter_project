import 'package:flutter/material.dart';
import 'package:teamapp/models/meeting.dart';
import 'package:teamapp/widgets/loading.dart';
import 'package:teamapp/widgets/meeting/meeting_card.dart';

class FutureList extends StatefulWidget {
  final Future<List<Meeting>> meetings;

  FutureList(this.meetings);

  @override
  _FutureListState createState() => _FutureListState();
}

class _FutureListState extends State<FutureList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Meeting>>(
        future: widget.meetings,
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
