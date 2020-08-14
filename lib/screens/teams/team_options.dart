import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/records_list.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/teams/team_add_user.dart';
import 'package:teamapp/screens/userProfile/mainUserProfilePage.dart';
import 'package:teamapp/services/firestore/record_lists.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';
import 'package:teamapp/widgets/general/dialogs/alert_dialog.dart';
import 'package:teamapp/widgets/general/dialogs/dialogs.dart';
import 'package:teamapp/widgets/general/diamond_image.dart';
import 'package:teamapp/widgets/general/editViewImage.dart';
import 'package:teamapp/widgets/loading.dart';
import 'package:teamapp/widgets/teams/team_user_card.dart';
import 'package:teamapp/widgets/teams/team_user_dialog.dart';

class TeamOptionsPage extends StatefulWidget {
  final Team team;

  TeamOptionsPage({@required this.team});

  @override
  _TeamOptionsPageState createState() => _TeamOptionsPageState();
}

class _TeamOptionsPageState extends State<TeamOptionsPage> {
  Team team;
  List<User> users;

  User currentUser;
  bool isInTeam;
  bool isAdmin;
  bool hasAutoJoin;

  bool isLoading = true;
  bool hasLoaded = false;

  loadWidgetOnce() async {
    if (hasLoaded) return;
    team = widget.team;
    currentUser = Provider.of<User>(context);
    isAdmin = team.ownerUid == currentUser.uid;
    await loadUsers();
    if (isInTeam) {
      hasAutoJoin = await TeamDataManager.teamToUsers.isUserAutoJoin(team.tid, currentUser.uid);
    }
    hasLoaded = true;
    setState(() => isLoading = false);
  }

  reloadWidget() async {
    setState(() => isLoading = true);
    await loadUsers();
    setState(() => isLoading = false);
  }

  loadUsers() async {
    isInTeam = false;
    users = [];
    RecordList usersList = await TeamToUsers().getRecordsList(widget.team.tid);
    for (final uid in usersList.data) {
      User user = await UserDataManager.getUser(uid);
      users.add(user);
      if (user.uid == currentUser.uid) {
        isInTeam = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loadWidgetOnce();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double top = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: isLoading
            ? Loading()
            : SingleChildScrollView(
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
                    SizedBox(height: 30),
                    DiamondImage(
                      size: 150,
                      imageProvider: NetworkImage(team.remoteStorageImage.url),
                      callback: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return EditViewImage(
                            imageProvider: NetworkImage(team.remoteStorageImage.url),
                            onSaveNewImageFile: (file) async {
                              await TeamDataManager.updateTeamImage(team, file);
                              setState(() {});
                            },
                            heroTag: "teamProfileImage",
                            mode: isAdmin ? EditViewImageMode.ViewAndEdit : EditViewImageMode.ViewOnly,
                          );
                        }));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Divider(thickness: 2),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Text(
                            team.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
                          ),
                          !isAdmin
                              ? SizedBox(height: 0, width: 0)
                              : Positioned(
                                  right: 30,
                                  child: GestureDetector(
                                    child: Icon(Icons.edit, size: 21),
                                    onTap: () async {
                                      String newName = await Dialogs.showTextInputDialog(context, "team name");
                                      if (newName.isNotEmpty) {
                                        TeamDataManager.updateTeamField(team, TeamField.NAME, newName);
                                        setState(() {});
                                      }
                                    },
                                  ),
                                )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Text(
                            team.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          !isAdmin
                              ? SizedBox(height: 0, width: 0)
                              : Positioned(
                                  right: 30,
                                  child: GestureDetector(
                                    child: Icon(Icons.edit, size: 21),
                                    onTap: () async {
                                      String newDescription = await Dialogs.showTextInputDialog(context, "description");
                                      if (newDescription.isNotEmpty) {
                                        TeamDataManager.updateTeamField(team, TeamField.DESCRIPTION, newDescription);
                                        setState(() {});
                                      }
                                    },
                                  ),
                                )
                        ],
                      ),
                    ),
                    Tooltip(
                      message: !team.isPublic
                          ? "Private means the team won't show up in searches."
                          : "Public means the team will show up in searches.",
                      child: Container(
                        padding: EdgeInsets.only(bottom: 25),
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Text(
                              !team.isPublic ? "This team is private." : "This team is public.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black87, fontSize: 16),
                            ),
                            !isAdmin
                                ? SizedBox(height: 0, width: 0)
                                : Positioned(
                                    right: 30,
                                    child: Switch(
                                      value: team.isPublic,
                                      onChanged: (value) {
                                        TeamDataManager.updateTeamField(team, TeamField.IS_PUBLIC, value);
                                        setState(() {});
                                      },
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: !isInTeam
                          ? Container()
                          : Tooltip(
                              message: "Join automatically to all new meetings of this team",
                              child: Container(
                                padding: EdgeInsets.only(bottom: 25),
                                width: double.infinity,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Automatically join new meetings",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black87, fontSize: 16),
                                    ),
                                    Positioned(
                                      right: 30,
                                      child: Switch(
                                        value: hasAutoJoin,
                                        onChanged: (value) {
                                          hasAutoJoin = !hasAutoJoin;
                                          TeamDataManager.teamToUsers
                                              .updateUserAutoJoin(team.tid, currentUser.uid, hasAutoJoin);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),

                    Container(
                      margin: EdgeInsets.all(10),
                      color: Colors.blue[400],
                      height: 60,
                      width: width - 20,
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
                          !isAdmin
                              ? SizedBox(height: 0, width: 0)
                              : Positioned(
                                  right: 10,
                                  child: IconButton(
                                      icon: Icon(Icons.add, color: Colors.white, size: 25),
                                      onPressed: () async {
                                        dynamic didSomethingChange = await Navigator.of(context)
                                            .push(MaterialPageRoute(builder: (context) => TeamAddUser(team: team)));
                                        if (didSomethingChange != null && didSomethingChange) {
                                          reloadWidget();
                                        }
                                      }),
                                )
                        ],
                      ),
                    ),
                    Container(
                      child: ListView.separated(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return Container(
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                child: UserCard(
                                  user: users[index],
                                  trailing:
                                      users[index].uid != team.ownerUid ? SizedBox(width: 0, height: 0) : Text('Admin'),
                                  callback: () async {
                                    User user = users[index];
                                    await showDialog(
                                        context: context,
                                        builder: (ctx) => TeamUserDialog(
                                              user: user,
                                              isAdmin: isAdmin,
                                              viewProfileCallback: () {
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => MainUserProfilePage(user: user)));
                                              },
                                              removeUserCallback: () {
                                                _removeUser(user);
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
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: !isInTeam
                          ? Container()
                          : RaisedButton(
                              elevation: 10,
                              onPressed: isLoading ? null : _leaveTeam,
                              child: Text(
                                "Leave Team",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              color: Colors.red[900],
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _leaveTeam() async {
    bool shouldRemove = await showDialog(
        context: context,
        builder: (ctx) => GeneralAlertDialog(
              title: 'Alert',
              content: "Are you sure you want to leave ${team.name}?",
              confirmCallback: () {
                Navigator.of(context).pop(true);
              },
              cancelCallback: () {
                Navigator.of(context).pop(false);
              },
            ));

    if (shouldRemove) {
      setState(() => isLoading = true);
      if (isAdmin) {
        if (users.length > 1) {
          for (User user in users) {
            if (user.uid == currentUser.uid) {
              continue;
            }
            print('${user.uid} and ${currentUser.uid}');
            await TeamDataManager.updateTeamField(team, TeamField.OWNER_UID, user.uid);
          }
        } else {
          // delete team
        }
      }
      await TeamDataManager.removeUserFromTeam(team, newUser: currentUser);
      Navigator.of(context).pop(true);
    }
  }

  void _removeUser(User user) async {
    bool shouldRemove = await showDialog(
        context: context,
        builder: (ctx) => GeneralAlertDialog(
              title: 'Alert',
              content: "Are you sure you want to remove " +
                  user.firstName +
                  " " +
                  user.lastName +
                  " from " +
                  team.name +
                  "?",
              confirmCallback: () {
                Navigator.of(context).pop(true);
              },
              cancelCallback: () {
                Navigator.of(context).pop(false);
              },
            ));

    if (shouldRemove) {
      TeamDataManager.removeUserFromTeam(team, newUser: user);
      reloadWidget();
      Navigator.of(context).pop();
    }
  }
}
