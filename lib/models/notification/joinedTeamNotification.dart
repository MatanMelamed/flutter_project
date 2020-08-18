import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/notification/notification.dart' as base;
import 'package:teamapp/models/team.dart';
import 'package:teamapp/screens/teams/team_page.dart';
import 'package:teamapp/screens/userProfile/mainUserProfilePage.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';
import 'package:timeago/timeago.dart' as tAgo;


class JoinedTeamNotification implements base.Notification {

  String type;
  String _memberName;
  var metadata = [];

  DocumentSnapshot _docFromOther;
  String _imageUrl;

  Team _team;
  String _teamName;
  Timestamp _timestamp;
  JoinedTeamNotification({this.type, this.metadata});



  @override
  Widget getWidget(context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 2.0),
        child: Container(
          color: Colors.white,
          child: ListTile(
            title: GestureDetector(
              onTap: () {
                var userProfile =
                UserDataManager.createUserFromDoc(_docFromOther);
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MainUserProfilePage(user: userProfile)));
              },
              child: RichText(
                overflow: TextOverflow.clip,
                text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(
                          text: _memberName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " joined your team "),
                      TextSpan(
                          text: _teamName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ]),
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(_imageUrl),
            ),
            subtitle: Text(
              tAgo.format(_timestamp.toDate()),
              overflow: TextOverflow.ellipsis,
            ),
//            trailing: acceptOrReject(),
          ),
        ));
  }

  @override
  Future<bool> handleMapFromDB(
      Timestamp timestamp, Map<String, dynamic> metadata) async {

    String fromID = metadata['fromID'];
    _docFromOther =
    await Firestore.instance.collection("users").document(fromID).get();
    _imageUrl = _docFromOther.data['imageUrl'];
    _memberName = _docFromOther.data['first_name'] + _docFromOther.data['last_name'];

    String teamId = metadata['teamId'];

    _team = await TeamDataManager.getTeam(teamId);
    if (_team == null) {
      return false;
    }
    _teamName = _team.name;
    _timestamp = timestamp;
    return true;
  }
}