import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/records_list.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/storageImage.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/services/firestore/ChatDataManager.dart';
import 'package:teamapp/services/firestore/meetingDataManager.dart';
import 'package:teamapp/services/firestore/record_lists.dart';
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
      'name': team.name,
      'description': team.description,
      'isPublic': team.isPublic,
      'owner': team.ownerUid,
      'messages': messagesDocRef.documentID
    });

    // Sending notifications to all team members
    TeamNotificationManager.sendTeamNotifications(team.ownerUid, usersList.data,docRef.documentID);


    // users list must contain at least the creator of the team - the owner
    usersList = usersList == null
        ? RecordList.fromWithinApp(data: [team.ownerUid])
        : (usersList.data.length > 0 ? usersList : RecordList.fromWithinApp(data: [team.ownerUid]));

    // register team on firestore
    RecordList userList = await teamToUsers.createRecordList(recordList: usersList, documentName: docRef.documentID);

    // create new team to meetings tracking
    RecordList meetingsList = await teamToMeetings.createRecordList(documentName: docRef.documentID);

    // add and register image
    StorageImage image = await StorageManager.saveImage(teamImage, 'teamProfiles/' + docRef.documentID);

    docRef.updateData({
      'imageUrl': image.url,
      'imagePath': image.path,
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

  static void updateTeamName(Team team, String newName) {
    team.name = newName;
    DocumentReference docRef = teamsCollection.document(team.tid);
    docRef.updateData({'name': newName});
  }

  static void updateTeamDescription(Team team, String newDescription) {
    team.description = newDescription;
    DocumentReference docRef = teamsCollection.document(team.tid);
    docRef.updateData({'description': newDescription});
  }

  static void updateTeamImage(Team team, File newImage) async {
    team.remoteStorageImage = await StorageManager.updateStorageImage(newImage, team.remoteStorageImage);
    DocumentReference docRef = teamsCollection.document(team.tid);
    docRef.updateData({'imageUrl': team.remoteStorageImage.url});
  }

  static void updateTeamPrivacy(Team team, bool newValue) {
    team.isPublic = newValue;
    DocumentReference docRef = teamsCollection.document(team.tid);
    docRef.updateData({'isPublic': newValue});
  }

  static Future<Team> getTeam(String tid) async {
    Team team;
    DocumentSnapshot docSnap = await teamsCollection.document(tid).get();

    if (docSnap.exists) {
      Map<String, dynamic> data = docSnap.data;
      team = new Team.fromDatabase(
        tid: docSnap.documentID,
        remoteStorageImage: StorageImage(url: data['imageUrl'], path: data['imagePath']),
        name: data['name'],
        description: data['description'],
        isPublic: data['isPublic'],
        ownerUid: data['owner'],
        chatId: data['messages'],
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

    await teamToUsers.addRecord(team.tid, uid);
    await userToTeams.addRecord(uid, team.tid);
    await MeetingDataManager.userAddedToTeam(team.tid, uid);
    return true;
  }

  static Future<void> removeUserFromTeam(Team team, {User newUser, String newUserUid}) async{
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
    for (String tid in userTeamsRecordList.data){
      teams.add(await getTeam(tid));
    }
    return teams;
  }

  static Future<void> deleteTeam(String tid) async {
    DocumentSnapshot team = await teamsCollection.document(tid).get();

    String chatId = team.data["messages"];

    // delete team for all users
    RecordList users_in_team = await teamToUsers.getRecordsList(tid);

    for (String uid in users_in_team.data){
      userToTeams.removeRecord(uid, tid);
    }

    // delete team-to-users record list
    teamToUsers.deleteRecordsList(tid);

    // Deletes User's List & Messages List, corresponding to the deleted team.
    await ChatDataManager.deleteChat(chatId);
    await teamsCollection.document(tid).delete();
  }
}
