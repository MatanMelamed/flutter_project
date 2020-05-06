import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/group.dart';
import 'package:teamapp/models/storageImage.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/services/firestore/GroupDataManager.dart';
import 'package:teamapp/services/firestore/firestoreManager.dart';

class TeamDataManager {
  static final CollectionReference teamsCollection = Firestore.instance.collection("teams");

  static Future<Team> createTeam(Team team, File teamImage, {Group group}) async {
    DocumentReference docRef = await teamsCollection.add({
                                                           'name': team.name,
                                                           'description': team.description,
                                                           'isPrivate': team.isPrivate,
                                                           'owner': team.ownerUid,
                                                         });
    // register group on firestore
    Group createdGroup = await GroupDataManager.createGroup(group ?? Group.fromWithinApp(membersUids: []));

    // add and register image
    StorageImage image = await StorageManager.saveImage(teamImage, docRef.documentID);

    docRef.updateData({'imageUrl': image.url, 'imagePath': image.path, 'membersGid': createdGroup.gid});

    return Team.fromDatabase(
        tid: docRef.documentID,
        imageUrl: image.url,
        imageRemotePath: image.path,
        ulid: 'null',
        name: team.name,
        description: team.description,
        isPrivate: team.isPrivate,
        ownerUid: team.ownerUid);
  }

  static Future<Team> getTeam(String tid) async {
    Team team;
    DocumentSnapshot docSnap = await teamsCollection.document(tid).get();

    if (docSnap.exists) {
      Map<String, dynamic> data = docSnap.data;
      team = new Team.fromDatabase(
          tid: docSnap.documentID,
          imageUrl: data['imageUrl'],
          imageRemotePath: data['imagePath'],
          ulid: data['usersListID'],
          name: data['name'],
          description: data['description'],
          isPrivate: data['isPrivate'],
          ownerUid: data['owner']);
    } else {
      print('Tried to get nonexistent team id');
    }

    return team;
  }
}
