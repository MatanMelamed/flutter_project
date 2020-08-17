import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:teamapp/models/meeting.dart';
import 'package:teamapp/models/notification/notification.dart';
import 'package:teamapp/models/records_list.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/models/storageImage.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/services/firestore/ChatDataManager.dart';
import 'package:teamapp/services/firestore/baseListDataManager.dart';
import 'package:teamapp/services/firestore/meetingDataManager.dart';
import 'package:teamapp/services/firestore/record_lists.dart';
import 'package:teamapp/services/firestore/usersListDataManager.dart';
import 'package:teamapp/services/firestore/firestoreManager.dart';
import 'package:teamapp/services/firestore/notifications/teamNotificationManager.dart';

class TeamDataManager {
  static final CollectionReference teamsCollection = Firestore.instance.collection("teams");
  static final CollectionReference messagesCollection = Firestore.instance.collection("messages");

  static TeamToMeetings teamToMeetings = TeamToMeetings();
  static TeamToUsers teamToUsers = TeamToUsers();

  static UserToTeams userToTeams = UserToTeams();
  static UserToMeetings userToMeetings = UserToMeetings();

  static Future<Team> createTeam(Team team, File teamImage, {RecordList usersList}) async {
    DocumentReference messagesDocRef = messagesCollection.document();
    await messagesDocRef.setData({});

    DocumentReference docRef = await teamsCollection.add({
      EnumToString.parse(TeamField.NAME): team.name,
      EnumToString.parse(TeamField.DESCRIPTION): team.description,
      EnumToString.parse(TeamField.IS_PUBLIC): team.isPublic,
      EnumToString.parse(TeamField.OWNER_UID): team.ownerUid,
      EnumToString.parse(TeamField.CHAT_ID): messagesDocRef.documentID
    });

    // Sending notifications to all team members
    TeamNotificationManager.sendTeamNotifications(team.ownerUid, usersList.data, docRef.documentID);

    // users list must contain at least the creator of the team - the owner
    usersList = usersList ?? RecordList.fromWithinApp(data: [team.ownerUid]);

    // register team on firestore
    RecordList userList = await teamToUsers.createRecordList(recordList: usersList, documentName: docRef.documentID);

    // create new team to meetings tracking
    RecordList meetingsList = await teamToMeetings.createRecordList(documentName: docRef.documentID);

    // add and register image
    StorageImage image = await StorageManager.saveImage(teamImage, 'teamProfiles/' + docRef.documentID);

    docRef.updateData({
      EnumToString.parse(TeamField.IMAGE) + "_URL": image.url,
      EnumToString.parse(TeamField.IMAGE) + "_PATH": image.path,
    });

    for (String uid in usersList.data) userToTeams.addRecord(uid, docRef.documentID);

    return Team.fromDatabase(
        tid: docRef.documentID,
        remoteStorageImage: image,
        name: team.name,
        description: team.description,
        isPublic: team.isPublic,
        ownerUid: team.ownerUid,
        chatId: messagesDocRef.documentID);
  }

  static void updateTeamImage(Team team, File newImage) async {
    team.remoteStorageImage = await StorageManager.updateStorageImage(newImage, team.remoteStorageImage);
    DocumentReference docRef = teamsCollection.document(team.tid);
    docRef.updateData({EnumToString.parse(TeamField.IMAGE) + "_URL": team.remoteStorageImage.url});
  }

//  static void updateTeamPrivacy(Team team, bool newValue) {
//    team.isPublic = newValue;
//    DocumentReference docRef = teamsCollection.document(team.tid);
//    docRef.updateData({'isPublic': newValue});
//  }

  // changes after creation
  static Future<void> updateTeamField(Team team, TeamField field, dynamic newValue) async {
    if (field == TeamField.IMAGE) return; // shouldn't be updated here!
    team.propAccess(field, newValue: newValue);
    DocumentReference docRef = teamsCollection.document(team.tid);
    await docRef.updateData({EnumToString.parse(field): newValue});
  }

  static Future<Team> getTeam(String tid) async {
    Team team;
    DocumentSnapshot docSnap = await teamsCollection.document(tid).get();

    if (docSnap.exists) {
      Map<String, dynamic> data = docSnap.data;
      team = new Team.fromDatabase(
        tid: docSnap.documentID,
        remoteStorageImage: StorageImage(
          url: data[EnumToString.parse(TeamField.IMAGE) + "_URL"],
          path: data[EnumToString.parse(TeamField.IMAGE) + "_PATH"],
        ),
        name: data[EnumToString.parse(TeamField.NAME)],
        description: data[EnumToString.parse(TeamField.DESCRIPTION)],
        isPublic: data[EnumToString.parse(TeamField.IS_PUBLIC)],
        ownerUid: data[EnumToString.parse(TeamField.OWNER_UID)],
        chatId: data[EnumToString.parse(TeamField.CHAT_ID)],
      );
    } else {
      print('Tried to get nonexistent team id $tid');
    }

    return team;
  }

  static Future<bool> addUserToTeam(Team team, {User newUser, String newUserUid}) async {
    String uid = newUser != null ? newUser.uid : newUserUid;
    if (uid == null || uid.isEmpty) {
      print('error in recording new team for null user.');
      return false;
    }
    //send notification
    TeamNotificationManager.sendTeamNotificationToUser(
        newUserUid,
        team.tid,
        Notification(type: 'addedToTeamNotification', metadata: {
          'viewed': false,
          'teamId': team.tid,
        }));

    await teamToUsers.addRecord(team.tid, uid);
    await userToTeams.addRecord(uid, team.tid);
    await MeetingDataManager.userAddedToTeam(team.tid, uid);
    return true;
  }

  static Future<void> removeUserFromTeam(Team team, {User newUser, String newUserUid}) async {
    String uid = newUser != null ? newUser.uid : newUserUid;
    if (uid == null || uid.isEmpty) {
      print('error in recording new team for null user.');
      return false;
    }
    await teamToUsers.removeRecord(team.tid, uid);
    await userToTeams.removeRecord(uid, team.tid);
    await MeetingDataManager.userRemovedFromTeam(team.tid, uid);
    return true;
  }

  static Future<List<Team>> getUserTeams(User user) async {
    RecordList userTeamsRecordList = await userToTeams.getRecordsList(user.uid);
    List<Team> teams = [];
    for (String tid in userTeamsRecordList.data) {
      teams.add(await getTeam(tid));
    }
    return teams;
  }

  static Future<void> deleteTeam(String tid) async {
    DocumentSnapshot team = await teamsCollection.document(tid).get();

    String chatId = team.data[EnumToString.parse(TeamField.CHAT_ID)];

    // delete team for all users
    RecordList usersInTeam = await teamToUsers.getRecordsList(tid);

    for (String uid in usersInTeam.data) {
      userToTeams.removeRecord(uid, tid);
    }

    // delete team-to-users record list
    teamToUsers.deleteRecordsList(tid);

    // Deletes User's List & Messages List, corresponding to the deleted team.
    await ChatDataManager.deleteChat(chatId);
    await teamsCollection.document(tid).delete();
  }
}
