import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/records_list.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/widgets/authenticate/inputs.dart';
import 'package:teamapp/widgets/loading.dart';
import 'package:teamapp/widgets/teams/team_card.dart';
import 'package:teamapp/widgets/dialogs/join_dialog.dart';
import 'package:teamapp/services/firestore/record_lists.dart';
import 'package:teamapp/services/firestore/notifications/teamNotificationManager.dart';
import 'package:teamapp/models/notification/notification.dart' as base;


class SearchTeamPage extends StatefulWidget {
  @override
  _SearchTeamPageState createState() => _SearchTeamPageState();
}

class _SearchTeamPageState extends State<SearchTeamPage> {
  TextEditingController _prefix;
  List<Team> _suggested;
  User _currentUser;
  String check;

  @override
  void initState() {
    super.initState();
    this._prefix = TextEditingController();
    this._suggested = List();
  }

  InputDecoration _getDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.all(15.0),
      alignLabelWithHint: true,
      hintText: 'Search Teams',
    );
  }

  Widget getBuilder(BuildContext context,
      AsyncSnapshot<dynamic> snapshot,) {
    return !snapshot.hasData
        ? Loading()
        : ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data.length,
      itemBuilder: (_, i) {
        return snapshot.data.isNotEmpty
            ? TeamCard(
          team: snapshot.data[i],
          onTap: () {
            showJoinAlert(context, snapshot.data[i]);
            setState(() {});
          },
        )
            : Text("ERROR");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Teams'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: this._prefix,
              onChanged: (value) => setState(() {}),
              decoration: this._getDecoration(),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: TeamDataManager.fromPrefix(_prefix.text),
                    builder: getBuilder,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  void showJoinAlert(BuildContext context, Team team) async {
    bool isInTeam = await checkIfUserInTeam(team);
    if (isInTeam) {
      await showDialog(
          context: context,
          builder: (_) =>
          new Dialog(
              elevation: 15,
              child: Container(
                  color: Colors.black12,
                  child: Wrap(
                    runSpacing: 30,
                    children: <Widget>[
                  Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0.0, 4.0), blurRadius: 2.0)],
                  ),
                height: 50,
                width: double.infinity,
                child: Center(
                  child: Text(
                    team.name,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Container(
              child: Text(
                "     You're already on this team! :)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
              Container(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      width: 180,
                      child: RaisedButton(
                        elevation: 10,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        color: Colors.blue[900],
                      ),
                    ),
                  ))
                  ])
          )));
    }

    else {
      await showDialog(context: context,
          builder: (context) =>
              JoinDialog(
                title: team.name,
                content: team.description,
                // ADD USER TO THIS TEAM
                confirmCallback: () async {
                  bool result = await TeamDataManager.addUserToTeam(
                      team, newUser: _currentUser);
                  if (result == true) {
                    //send notification
                    TeamNotificationManager.sendJoinedNotification(
                        _currentUser.uid,
                        team.ownerUid,
                        team.tid,
                        "joinedTeamNotifications",
                        base.Notification(
                            type: 'joinedTeamNotification', metadata: {
                          'viewed': false,
                          'fromID': _currentUser.uid,
                          'teamId': team.tid,
                        }));
                  }

                  setState(() => Navigator.of(context).pop());
                },
                cancelCallback: () =>
                    Navigator.of(context).pop(),
              )
      );
    }
  }

  Future<bool> checkIfUserInTeam(Team team) async  {
    RecordList usersList = await TeamToUsers().getRecordsList(team.tid);
    for (final uid in usersList.data) {
      if (uid == _currentUser.uid) {
        return true;
      }
    }
    return false;
  }


}