import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/models/storageImage.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/services/firestore/usersListDataManager.dart';
import 'package:teamapp/services/firestore/firestoreManager.dart';

class TeamDataManager {
  static final CollectionReference teamsCollection =
      Firestore.instance.collection("teams");

  static Future<Team> createTeam(Team team, File teamImage,
      {UsersList group}) async {
    DocumentReference docRef = await teamsCollection.add({
      'name': team.name,
      'description': team.description,
      'isPublic': team.isPublic,
      'owner': team.ownerUid,
    });
    // register group on firestore
    UsersList createdUsersList = await UsersListDataManager.createUsersList(
        group ?? UsersList.fromWithinApp(membersUids: []));

    // add and register image
    StorageImage image =
        await StorageManager.saveImage(teamImage, docRef.documentID);

    docRef.updateData({
      'imageUrl': image.url,
      'imagePath': image.path,
      'ulid': createdUsersList.ulid
    });

    return Team.fromDatabase(
        tid: docRef.documentID,
        remoteImage: image,
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

  static void addUserToTeam(Team team, User newUser) {
    UsersListDataManager.addUser(team.ulid, newUser.uid);
  }

  static void removeUserFromTeam(Team team, User user) {
    UsersListDataManager.removeUser(team.ulid, user.uid);
  }

  static void updateTeamImage(Team team, File newImage) async {
    team.remoteImage =
        await StorageManager.updateImage(newImage, team.remoteImage.path);
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
          remoteImage:
              StorageImage(url: data['imageUrl'], path: data['imagePath']),
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
}
