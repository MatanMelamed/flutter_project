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
import 'package:teamapp/services/firestore/usersListDataManager.dart';
import 'package:teamapp/services/general/utilites.dart';
import 'package:teamapp/widgets/general/date_time.dart';
import 'package:teamapp/widgets/general/dialogs/dialogs.dart';
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
  String publicDisclaimer = '';
  bool isLoading = false;
  bool isAdmin = true;
  bool editMode = false;
  List<User> users;

  @override
  void initState() {
    super.initState();
    updatePublicity();
    loadUsers();
  }

  updatePublicity() {
    publicDisclaimer = widget.meeting.isPublic ? 'This meeting is public.' : 'This meeting is private.';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<User>(context);
    setState(() => isAdmin = user.uid == widget.ownerUID);
  }

  loadUsers() async {
    setState(() => isLoading = true);
    users = [];
    RecordList usersList = await MeetingToUsers().getRecordsList(widget.meeting.mid);
    //UsersList usersList = await UsersListDataManager.getUsersList(widget.meeting.arrivalConfirmsULID);
    for (final uid in usersList.data) {
      User user = await UserDataManager.getUser(uid);
      users.add(user);
    }
    setState(() => isLoading = false);
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
                  Text(
                    users.length > 0 ? "     " + users.length.toString() : "",
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: editMode ? () => updateMeetingField('meeting\'s name', MeetingField.NAME) : () {},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.meeting.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                          ),
                          decoration: BoxDecoration(
                              color: editMode ? Colors.blue[100] : Colors.transparent,
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
                                onPressed: () => setState(() => editMode = !editMode),
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
                    onTap:
                        editMode ? () => updateMeetingField('meeting\'s description', MeetingField.DESCRIPTION) : () {},
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget.meeting.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black45),
                      ),
                      decoration: BoxDecoration(
                          color: editMode ? Colors.blue[100] : Colors.transparent,
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
                          Icon(Icons.location_on),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: editMode
                                ? () => updateMeetingField('meeting\'s location', MeetingField.LOCATION)
                                : () {},
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                '${widget.meeting.location}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                              ),
                              decoration: BoxDecoration(
                                  color: editMode ? Colors.blue[100] : Colors.transparent,
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
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                              ),
                              decoration: BoxDecoration(
                                  color: editMode ? Colors.blue[100] : Colors.transparent,
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
                            onTap: editMode
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
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[800]),
                              ),
                              decoration: BoxDecoration(
                                  color: editMode ? Colors.blue[100] : Colors.transparent,
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
                            onTap: editMode
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
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[800]),
                              ),
                              decoration: BoxDecoration(
                                  color: editMode ? Colors.blue[100] : Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(30))),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 35),
                getUsersListView()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
