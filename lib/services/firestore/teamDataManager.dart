import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/models/storageImage.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/services/firestore/usersListDataManager.dart';
import 'package:teamapp/services/firestore/firestoreManager.dart';

class TeamDataManager {
  static final CollectionReference teamsCollection = Firestore.instance.collection("teams");
  static final CollectionReference userTeamCollection = Firestore.instance.collection("user_teams");

  static final String allUserTeams = "InTeams"; // the teams that the user is in them

  static Future<Team> createTeam(Team team, File teamImage, {UsersList usersList}) async {
    DocumentReference docRef = await teamsCollection.add({
      'name': team.name,
      'description': team.description,
      'isPublic': team.isPublic,
      'owner': team.ownerUid,
    });

    // register team on firestore
    UsersList createdUsersList =
        await UsersListDataManager.createUsersList(usersList ?? UsersList.fromWithinApp(membersUids: []));

    // add and register image
    StorageImage image = await StorageManager.saveImage(teamImage, 'teamProfiles/' + docRef.documentID);

    docRef.updateData({'imageUrl': image.url, 'imagePath': image.path, 'ulid': createdUsersList.ulid});

    // add team to user's teams
    recordNewTeamForUser(docRef.documentID, team.ownerUid);

    return Team.fromDatabase(
        tid: docRef.documentID,
        remoteStorageImage: image,
        ulid: createdUsersList.ulid,
        name: team.name,
        description: team.description,
        isPublic: team.isPublic,
        ownerUid: team.ownerUid);
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
          ulid: data['ulid'],
          name: data['name'],
          description: data['description'],
          isPublic: data['isPublic'],
          ownerUid: data['owner']);
    } else {
      print('Tried to get nonexistent team id');
    }

    return team;
  }

  static Future<bool> recordNewTeamForUser(String tid, String uid) async {
    DocumentReference userTeamsRef = userTeamCollection.document(uid);
    DocumentSnapshot snapshot = await userTeamsRef.get();

    // user doesn't have teams yet, it's his first team, then create his tracking teams doc.
    if(!snapshot.exists){
      userTeamsRef.setData({});
    }

    DocumentReference newTeamRecord = userTeamsRef.collection(allUserTeams).document(tid);
    return newTeamRecord.setData({}).then((_) {
      return true;
    }).catchError((error) {
      print('error in recording new team $tid for user $uid.');
      return false;
    });
  }

  static Future<bool> addUserToTeam(Team team, {User newUser, String newUserUid}) async {
    String uid;
    if (newUser != null) {
      uid = newUser.uid;
    } else if (newUserUid.isNotEmpty) {
      uid = newUserUid;
    } else {
      print('error in recording new team for null user.');
      return false;
    }

    UsersListDataManager.addUser(team.ulid, uid);
    return recordNewTeamForUser(team.tid, uid);
  }

  static void removeUserFromTeam(Team team, {User newUser, String newUserUid}) {
    String uid;
    if (newUser != null) {
      uid = newUser.uid;
    } else if (newUserUid.isNotEmpty) {
      uid = newUserUid;
    } else {
      print('error in recording new team for null user.');
    }

    UsersListDataManager.removeUser(team.ulid, uid);
    userTeamCollection.document(uid).collection(allUserTeams).document(team.tid).delete();
  }

  static Future<List<Team>> getUserTeams(User user) async {
    List<Team> teams = [];
    DocumentReference userTeamsRef = userTeamCollection.document(user.uid);
    print(userTeamsRef.documentID);
    DocumentSnapshot userTeamsSnapshot = await userTeamsRef.get();

    if (userTeamsSnapshot.exists) {
      try {
        QuerySnapshot result = await userTeamsRef.collection(allUserTeams).getDocuments();
        // query snapshot is a query result, may contain docs.
        for (int i = 0; i < result.documents.length; i++) {
          DocumentSnapshot tidDoc = result.documents[i];
          teams.add(await getTeam(tidDoc.documentID));
        }
      } catch (e, s) {
        print(s);
      }
    }else{
      print('no teams found for user ${user.uid}');
    }

    return teams;
  }
}
