import 'package:flutter/material.dart';
import 'package:teamapp/models/meeting.dart';
import 'package:teamapp/screens/meetings/meeting_page.dart';
import 'package:teamapp/services/firestore/meetingDataManager.dart';

class ViewMeetingTester extends StatefulWidget {
  @override
  _ViewMeetingTesterState createState() => _ViewMeetingTesterState();
}

class _ViewMeetingTesterState extends State<ViewMeetingTester> {
  Meeting meeting;

  loadTeam() async {
    meeting = await MeetingDataManager.getMeetingByMID('AfX0b7G4bY3yYkOo3WxK');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTeam();
  }

  @override
  Widget build(BuildContext context) {
    return meeting == null
        ? Container()
        : MeetingPage(
            meeting: meeting,
            ownerUID: 'C5h3rKCR9Rh7qbGmfc3didEuZlu1',
          );
  }
}
