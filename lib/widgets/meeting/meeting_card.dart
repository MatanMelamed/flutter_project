import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/meeting.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/meetings/meeting_page.dart';
import 'package:teamapp/services/firestore/meetingDataManager.dart';
import 'package:teamapp/services/firestore/record_lists.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/widgets/loading.dart';

import 'meeting_card_dialog.dart';

class MeetingCard extends StatefulWidget {
  final Meeting meeting;
  final String teamOwnerUid;
  final Widget trailing;
  final bool Function() onTap; // returns if something has changed in the meeting
  final void Function(bool hasChanged) afterTap;
  final VoidCallback onLongPress;

  MeetingCard({
    @required this.meeting,
    this.teamOwnerUid,
    this.trailing,
    this.onTap,
    this.afterTap,
    this.onLongPress,
  });

  @override
  _MeetingCardState createState() => _MeetingCardState();
}

class _MeetingCardState extends State<MeetingCard> {
  bool isLoading = true;

  int approvedCount;
  int totalCount;

  String teamOwnerUid;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    if (widget.teamOwnerUid == null) {
      Team team = await TeamDataManager.getTeam(widget.meeting.tid);
      teamOwnerUid = team.ownerUid;
    }
    await getApprovalCounters();
    setState(() => isLoading = false);
  }

  void reload() async{
    setState(() => isLoading = true);
    await getApprovalCounters();
    setState(() => isLoading = false);
  }

  void getApprovalCounters() async {
    var list = await MeetingToUsers().getCounters(widget.meeting.mid);
    totalCount = list[0];
    approvedCount = list[1];
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : GestureDetector(
            onLongPress: widget.onLongPress ?? _longPress,
            onTap: () async {
              bool hasChanged = await (widget.onTap ?? _onTap)();
              (widget.afterTap ?? (val) {})(hasChanged);
            },
            child: Container(
              height: 80,
              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 7, left: 10),
                        child: Text(
                          widget.meeting.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 20),
                        child: Text(
                          "${widget.meeting.sport.toString()}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 20),
                        child: Text(
                          widget.meeting.time.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15, right: 5),
                        child: Text(
                          "$approvedCount / $totalCount",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, right: 5),
                        child: Text(
                          '500 m',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Future<bool> _onTap() async {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MeetingPage(
          meeting: widget.meeting,
          ownerUID: widget.teamOwnerUid,
        ),
      ),
    );
  }

  void _longPress() async {
    User currentUser = Provider.of<User>(context, listen: false);
    bool isInMeeting = await MeetingToUsers().isUserInMeeting(widget.meeting.mid, currentUser.uid);
    bool isApproved = isInMeeting ? await MeetingToUsers().isUserApproved(widget.meeting.mid, currentUser.uid) : false;

    print('meeting card: $isInMeeting $isApproved');

    int selectedOption = await showDialog(
        context: context,
        builder: (ctx) => MeetingCardDialog(
              isInMeeting: isInMeeting,
              isApproved: isApproved,
            ));

    if (selectedOption != null) {
      print('selected option is $selectedOption');
      if (selectedOption == 0) {
        if (!isInMeeting) await _joinMeeting(widget.meeting, currentUser);
        if (isApproved)
          await _changeArrival(widget.meeting, currentUser, false);
        else
          await _changeArrival(widget.meeting, currentUser, true);
      } else if (selectedOption == 2) {
        if (isInMeeting)
          await _leaveMeeting(widget.meeting, currentUser);
        else
          await _joinMeeting(widget.meeting, currentUser);
      }
    }
  }

  void _changeArrival(Meeting meeting, User currentUser, bool newValue) async {
    print('change arrival $newValue');
    await MeetingToUsers().updateUserApproval(meeting.mid, currentUser.uid, newValue);
    reload();
  }

  void _joinMeeting(Meeting meeting, User currentUser) async {
    print('join');
    await MeetingDataManager.addUserToMeeting(meeting.mid, currentUser.uid);
    reload();
  }

  void _leaveMeeting(Meeting meeting, User currentUser) async {
    print('leave');
    await MeetingDataManager.removeUserFromMeeting(meeting.mid, currentUser.uid);
    reload();
  }
}
