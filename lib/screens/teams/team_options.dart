import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/screens/teams/team_add_user.dart';
import 'package:teamapp/screens/userProfile/mainUserProfilePage.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';
import 'package:teamapp/services/firestore/usersListDataManager.dart';
import 'package:teamapp/widgets/general/text_input_dialog.dart';
import 'package:teamapp/widgets/general/diamond_image.dart';
import 'package:teamapp/widgets/general/editViewImage.dart';
import 'package:teamapp/widgets/general/narrow_returnbar.dart';
import 'package:teamapp/widgets/loading.dart';
import 'package:teamapp/widgets/teams/team_alert.dart';
import 'package:teamapp/widgets/teams/team_user_card.dart';
import 'package:teamapp/widgets/teams/team_user_dialog.dart';

class TeamOptionsPage extends StatefulWidget {
  final Team team;
  final bool isAdmin;

  TeamOptionsPage({@required this.team, @required this.isAdmin});

  @override
  _TeamOptionsPageState createState() => _TeamOptionsPageState();
}

class _TeamOptionsPageState extends State<TeamOptionsPage> {
  Team team;
  List<User> users;
  bool loading;

  loadUsers() async {
    setState(() => loading = true);
    users = [];
    UsersList usersList = await UsersListDataManager.getUsersList('v7m9ZAgQLxc3ZJ3JRXdr');
    for (final uid in usersList.membersUids) {
      User user = await UserDataManager.getUser(uid);
      users.add(user);
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    team = widget.team;
    loadUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double top = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
//              IconButton(
//                icon: Icon(Icons.account_circle),
//                onPressed: () {
//                  isAdmin = !isAdmin;
//                  setState(() {});
//                },
//              ),
              GetNarrowReturnBar(context),
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
                      mode: widget.isAdmin ? EditViewImageMode.ViewAndEdit : EditViewImageMode.ViewOnly,
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
                    !widget.isAdmin
                        ? SizedBox(height: 0, width: 0)
                        : Positioned(
                            right: 30,
                            child: GestureDetector(
                              child: Icon(Icons.edit, size: 21),
                              onTap: () async {
                                String newName = await showTextInputDialog(context, "team name");
                                if (newName.isNotEmpty) {
                                  TeamDataManager.updateTeamName(team, newName);
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
                    !widget.isAdmin
                        ? SizedBox(height: 0, width: 0)
                        : Positioned(
                            right: 30,
                            child: GestureDetector(
                              child: Icon(Icons.edit, size: 21),
                              onTap: () async {
                                String newDescription = await showTextInputDialog(context, "description");
                                if (newDescription.isNotEmpty) {
                                  TeamDataManager.updateTeamDescription(team, newDescription);
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
                      !widget.isAdmin
                          ? SizedBox(height: 0, width: 0)
                          : Positioned(
                              right: 30,
                              child: Switch(
                                value: team.isPublic,
                                onChanged: (value) {
                                  print(value);
                                  TeamDataManager.updateTeamPrivacy(team, value);
                                  setState(() {});
                                },
                              ),
                            )
                    ],
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
                    !widget.isAdmin
                        ? SizedBox(height: 0, width: 0)
                        : Positioned(
                            right: 10,
                            child: IconButton(
                                icon: Icon(Icons.add, color: Colors.white, size: 25),
                                onPressed: () async {
                                  dynamic didSomethingChange = await Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => TeamAddUser(team: team)));
                                  if (didSomethingChange != null && didSomethingChange) {
                                    loadUsers();
                                  }
                                }),
                          )
                  ],
                ),
              ),
              Container(
                child: loading == true
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
                                trailing:
                                    users[index].uid != team.ownerUid ? SizedBox(width: 0, height: 0) : Text('Admin'),
                                callback: () async {
                                  User user = users[index];
                                  await showDialog(
                                      context: context,
                                      builder: (ctx) => TeamUserDialog(
                                            user: user,
                                            isAdmin: widget.isAdmin,
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
            ],
          ),
        ),
      ),
    );
  }

  void _removeUser(User user) async {
    bool shouldRemove = await showDialog(
        context: context,
        builder: (ctx) => TeamAlertDialog(
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
      TeamDataManager.removeUserFromTeam(team, user);
      setState(() {
        loadUsers();
      });
      Navigator.of(context).pop();
    }
  }
}
