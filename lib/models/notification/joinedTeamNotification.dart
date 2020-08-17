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
  String _name;
  var metadata = [];

  Team _team;
  String _teamName;
  DocumentSnapshot _ownerDoc;
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
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        TeamPage(team: _team)));
              },
              child: RichText(
                overflow: TextOverflow.clip,
                text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(
                          text: _name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: " has added you to "),
                      TextSpan(
                          text: _teamName,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: "'s team"),
                    ]),
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(_team.remoteStorageImage.url),
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

    String teamId = metadata['teamId'];
    _team = await TeamDataManager.getTeam(teamId);
    if (_team == null) {
      return false;
    }
    String leaderId = _team.ownerUid;
    _teamName = _team.name;
    _ownerDoc =
    await Firestore.instance.collection("users").document(leaderId).get();
    _name = _ownerDoc.data['first_name'] + _ownerDoc.data['last_name'];
    _timestamp = timestamp;
    return true;

  }


}