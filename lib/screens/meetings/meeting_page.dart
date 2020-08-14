import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/meeting.dart';
import 'package:teamapp/models/records_list.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/screens/userProfile/mainUserProfilePage.dart';
import 'package:teamapp/services/firestore/meetingDataManager.dart';
import 'package:teamapp/services/firestore/record_lists.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';
import 'package:teamapp/services/general/utilites.dart';
import 'package:teamapp/widgets/general/date_time.dart';
import 'package:teamapp/widgets/general/dialogs/alert_dialog.dart';
import 'package:teamapp/widgets/general/dialogs/dialogs.dart';
import 'package:teamapp/widgets/general/dialogs/meeting_approve_dialog.dart';
import 'package:teamapp/widgets/loading.dart';
import 'package:teamapp/widgets/teams/team_user_card.dart';
import 'package:teamapp/widgets/teams/team_user_dialog.dart';

class MeetingPage extends StatefulWidget {
  final String ownerUID;
  final Meeting meeting;

  MeetingPage({
    @required this.ownerUID,
    @required this.meeting,
  });

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  List<User> users;
  RecordList usersList;

  User currentUser;
  bool isAdmin = false;
  bool isInMeeting = false;
  bool inEditMode = false;
  bool isApproved = false;
  String publicDisclaimer;
  int approved = 0;

  bool isLoading = true;
  bool hasLoaded = false;

  loadWidgetOnce() async {
    if (hasLoaded) return;
    inEditMode = false;
    currentUser = Provider.of<User>(context);
    isAdmin = widget.ownerUID == currentUser.uid;
    await loadUsers();
    hasLoaded = true;
    updatePublicity();
    setState(() => isLoading = false);
  }

  loadUsers() async {
    isInMeeting = false;
    approved = 0;
    users = [];
    usersList = await MeetingToUsers().getRecordsList(widget.meeting.mid);
    for (final uid in usersList.data) {
      User user = await UserDataManager.getUser(uid);
      users.add(user);
      if (usersList.metadata[uid][MeetingToUsers.USER_APPROVAL_STATUS]) {
        approved += 1;
        isApproved = true;
      }
      if (user.uid == currentUser.uid) {
        isInMeeting = true;
      }
    }
  }

  Widget getUsersListView() {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.blue[400],
          height: 50,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Members",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "$approved / ${users.length}",
                    style: TextStyle(color: Colors.white60, fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Container(
          child: isLoading
              ? Container(
                  height: 150,
                  child: Loading(),
                )
              : ListView.separated(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: UserCard(
                          user: users[index],
                          trailing: users[index].uid != widget.ownerUID ? SizedBox(width: 0, height: 0) : Text('Admin'),
                          subtitle: Text(usersList.metadata[users[index].uid][MeetingToUsers.USER_APPROVAL_STATUS]
                              ? "Approved arrival"
                              : "Have not approved yet"),
                          callback: () async {
                            User user = users[index];
                            await showDialog(
                                context: context,
                                builder: (ctx) => TeamUserDialog(
                                      user: user,
                                      isAdmin: false,
                                      viewProfileCallback: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => MainUserProfilePage(user: user)));
                                      },
                                    ));
                          },
                        ));
                  },
                  separatorBuilder: (ctx, idx) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Divider(thickness: 2),
                      ),
                  itemCount: users.length),
        ),
      ],
    );
  }

  void updateMeetingField(String fieldName, MeetingField field) async {
    String newName = await Dialogs.showTextInputDialog(context, fieldName);
    if (newName.isNotEmpty) {
      MeetingDataManager.updateMeetingField(
        widget.meeting,
        field,
        newName,
      );
      setState(() {});
    }
  }

  void editTime() async {
    DateTime date = await selectDate(context);
    if (date == null) {
      return;
    }

    await MeetingDataManager.updateMeetingField(widget.meeting, MeetingField.TIME, date.toString());

    setState(() {});
  }

  updatePublicity() {
    publicDisclaimer = widget.meeting.isPublic ? 'This meeting is public.' : 'This meeting is private.';
  }

  @override
  Widget build(BuildContext context) {
    loadWidgetOnce();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: isLoading
            ? Loading()
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.account_circle),
                        onPressed: () {
                          isAdmin = !isAdmin;
                          setState(() {});
                        },
                      ),
                      //GetNarrowReturnBar(context),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap:
                                  inEditMode ? () => updateMeetingField('meeting\'s name', MeetingField.NAME) : () {},
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  widget.meeting.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                                ),
                                decoration: BoxDecoration(
                                    color: inEditMode ? Colors.blue[100] : Colors.transparent,
                                    borderRadius: BorderRadius.all(Radius.circular(30))),
                              ),
                            ),
                            !isAdmin
                                ? SizedBox(height: 0, width: 0)
                                : Positioned(
                                    right: 0,
                                    bottom: 7,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        size: 20,
                                      ),
                                      onPressed: () => setState(() => inEditMode = !inEditMode),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        color: Colors.black45,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: inEditMode
                              ? () => updateMeetingField('meeting\'s description', MeetingField.DESCRIPTION)
                              : () {},
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              widget.meeting.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20, color: Colors.black45),
                            ),
                            decoration: BoxDecoration(
                                color: inEditMode ? Colors.blue[100] : Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(30))),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.assignment_turned_in),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: _changeArrival,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Arrival:\t\t\t' + (isApproved ? 'Approved' : 'Not Approved'),
                                      style:
                                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                                    ),
                                    decoration: BoxDecoration(
                                        color: inEditMode ? Colors.blue[100] : Colors.transparent,
                                        borderRadius: BorderRadius.all(Radius.circular(30))),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: <Widget>[
                                Icon(Icons.location_on),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: inEditMode
                                      ? () => updateMeetingField('meeting\'s location', MeetingField.LOCATION)
                                      : () {},
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Meetings location',
                                      style:
                                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                                    ),
                                    decoration: BoxDecoration(
                                        color: inEditMode ? Colors.blue[100] : Colors.transparent,
                                        borderRadius: BorderRadius.all(Radius.circular(30))),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: <Widget>[
                                Icon(Icons.access_time),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: editTime,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      '${widget.meeting.time.toDisplayString()}',
                                      style:
                                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                                    ),
                                    decoration: BoxDecoration(
                                        color: inEditMode ? Colors.blue[100] : Colors.transparent,
                                        borderRadius: BorderRadius.all(Radius.circular(30))),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: <Widget>[
                                Icon(Icons.arrow_right),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: inEditMode
                                      ? () async {
                                          MeetingDataManager.updateMeetingField(
                                            widget.meeting,
                                            MeetingField.IS_PUBLIC,
                                            !widget.meeting.isPublic,
                                          );
                                          setState(() => updatePublicity());
                                        }
                                      : () {},
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      '$publicDisclaimer',
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[800]),
                                    ),
                                    decoration: BoxDecoration(
                                        color: inEditMode ? Colors.blue[100] : Colors.transparent,
                                        borderRadius: BorderRadius.all(Radius.circular(30))),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: <Widget>[
                                Icon(Icons.arrow_right),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: inEditMode
                                      ? () async {
                                          List<int> newRange = await Dialogs.showAgeSlider(
                                            context,
                                            widget.meeting.ageLimitStart,
                                            widget.meeting.ageLimitEnd,
                                          );
                                          if (newRange != null) {
                                            MeetingDataManager.updateMeetingField(
                                              widget.meeting,
                                              MeetingField.AGE_LIMIT_START,
                                              newRange[0],
                                            );
                                            MeetingDataManager.updateMeetingField(
                                              widget.meeting,
                                              MeetingField.AGE_LIMIT_END,
                                              newRange[1],
                                            );
                                            setState(() {});
                                          }
                                        }
                                      : () {},
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Marked for ages: ${widget.meeting.ageLimitStart} - ${widget.meeting.ageLimitEnd}',
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[800]),
                                    ),
                                    decoration: BoxDecoration(
                                        color: inEditMode ? Colors.blue[100] : Colors.transparent,
                                        borderRadius: BorderRadius.all(Radius.circular(30))),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 35),
                      getUsersListView(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GetLeaveJoinButton(),
                          !isAdmin
                              ? Container()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: RaisedButton(
                                        elevation: 10,
                                        onPressed: isLoading ? null : _deleteMeeting,
                                        child: Text(
                                          "Delete Meeting",
                                          style: TextStyle(color: Colors.white, fontSize: 16),
                                        ),
                                        color: Colors.red[900],
                                      ),
                                    )
                                  ],
                                )
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget GetLeaveJoinButton() {
    return !isInMeeting
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: RaisedButton(
              elevation: 10,
              onPressed: isLoading ? null : _joinMeeting,
              child: Text(
                "Join Meeting",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              color: Colors.green[900],
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: RaisedButton(
              elevation: 10,
              onPressed: isLoading ? null : _leaveMeeting,
              child: Text(
                "Leave Meeting",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              color: Colors.red[900],
            ),
          );
  }

  void _changeArrival() async {
    bool newValue = await showDialog(
      context: context,
      builder: (ctx) {
        return MeetingApproveDialog(
          firstValue: isApproved,
        );
      },
    );

    if (newValue != null) {
      setState(() => isLoading = true);
      isApproved = newValue;
      await MeetingToUsers().updateUserApproval(widget.meeting.mid, currentUser.uid, newValue);
      await loadUsers();
      setState(() => isLoading = false);
    }
  }

  void _deleteMeeting() async {
    bool shouldRemove = await showDialog(
        context: context,
        builder: (ctx) => GeneralAlertDialog(
              title: 'Alert',
              content: "Are you sure you want to delete this meeting?\nThis will delete the meeting for everyone else.",
              optionAText: "Delete Meeting",
              confirmCallback: () {
                Navigator.of(context).pop(true);
              },
              cancelCallback: () {
                Navigator.of(context).pop(false);
              },
            ));

    if (shouldRemove) {
      setState(() => isLoading = true);
      await MeetingDataManager.deleteMeetingByMID(widget.meeting.mid);
      Navigator.of(context).pop(true);
    }
  }

  void _joinMeeting() async {
    setState(() => isLoading = true);
    await MeetingDataManager.addUserToMeeting(widget.meeting.mid, currentUser.uid);
    await loadUsers();
    setState(() => isLoading = false);
  }

  void _leaveMeeting() async {
    setState(() => isLoading = true);
    await MeetingDataManager.removeUserFromMeeting(widget.meeting.mid, currentUser.uid);
    await loadUsers();
    setState(() => isLoading = false);
  }
}
