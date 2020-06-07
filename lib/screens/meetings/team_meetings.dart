import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/Tests/meeting/create_meeting_tester.dart';
import 'package:teamapp/models/meeting.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/meetings/meeting_page.dart';
import 'package:teamapp/services/firestore/meetingDataManager.dart';
import 'package:teamapp/services/firestore/record_lists.dart';
import 'package:teamapp/widgets/loading.dart';
import 'package:teamapp/widgets/meeting/meeting_card.dart';
import 'package:teamapp/widgets/teams/team_alert.dart';

class TeamMeetings extends StatefulWidget {
  final Team team;

  TeamMeetings({this.team});

  @override
  _TeamMeetingsState createState() => _TeamMeetingsState();
}

class _TeamMeetingsState extends State<TeamMeetings> {
  List<Meeting> meetings;
  bool isAdmin;
  bool isLoading;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isAdmin = Provider.of<User>(context).uid == widget.team.ownerUid;
    _loadMeetings();
  }

  _loadMeetings() async {
    setState(() => isLoading = true);
    meetings = await MeetingDataManager.getAllMeetingsOfATeam(widget.team.tid);
    setState(() => isLoading = false);
  }

  showAlertDialog(BuildContext context, Meeting meeting) async {
    await showDialog(
        context: context,
        builder: (context) => GeneralAlertDialog(
              title: 'Alert',
              content: 'Are You Sure You Want To Delete ${meeting.name}',
              confirmCallback: () async {
                await MeetingDataManager.deleteMeetingByMID(meeting.mid);
                meetings.remove(meeting);
                setState(() => Navigator.of(context).pop());
              },
              cancelCallback: () => Navigator.of(context).pop(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: RaisedButton(
                elevation: 10,
                color: Colors.blue,
                child: Text(
                  "Create a new meeting",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => CreateMeetingTester(
                        team: widget.team,
                        ),
                      ),
                    );
                },
              ),
            ),
            Expanded(
              child: isLoading
                  ? Loading()
                  : ListView.separated(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: meetings.length,
                      itemBuilder: (ctx, index) {
                        Meeting currentMeeting = meetings[index];
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: MeetingCard(
                            meeting: currentMeeting,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MeetingPage(
                                    meeting: currentMeeting,
                                    ownerUID: widget.team.ownerUid,
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              showAlertDialog(context, currentMeeting);
                              setState(() {});
                            },
                          ),
                        );
                      },
                      separatorBuilder: (ctx, idx) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(thickness: 2),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
