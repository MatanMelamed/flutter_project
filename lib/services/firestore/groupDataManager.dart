import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/group.dart';

class GroupDataManager {
  static final CollectionReference groupsCollection = Firestore.instance.collection("groups");

  static Future<Group> createGroup(Group group) async {
    DocumentReference docRef = await groupsCollection.document();

    for (var i = 0; i < group.membersUids.length; i++) {
      //docRef.collection("members").add({'user': group.membersUids[i]});
      docRef.collection("members").document(group.membersUids[i]);
    }

    return Group.fromDatabase(gid: docRef.documentID, membersUids: group.membersUids);
  }

  static Future<bool> addUser(String gid, String uid) async {
    groupsCollection.document(gid)
        .collection("members")
        .document(uid);
    return true;
  }

  static Future<bool> removeUser(String gid, String uid) async {
    groupsCollection.document(gid)
        .collection("members")
        .document(uid)
        .delete()
        .catchError((err) {
      print(err);
      return false;
    });
    return true;
  }
}
