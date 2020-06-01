import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/usersList.dart';

class UsersListDataManager {
  static final CollectionReference usersListsCollection = Firestore.instance.collection("users_lists");

  static Future<UsersList> createUsersList(UsersList usersList) async {
    DocumentReference docRef = usersListsCollection.document();
    docRef.setData({});

    for (var i = 0; i < usersList.membersUids.length; i++) {
      DocumentReference userDocRef = docRef.collection("members").document(usersList.membersUids[i]);
      userDocRef.setData({});
    }

    return UsersList.fromDatabase(ulid: docRef.documentID, membersUids: usersList.membersUids);
  }

  static Future<bool> addUser(String ulid, String uid) async {
    DocumentReference userDocRef = usersListsCollection.document(ulid).collection("members").document(uid);
    userDocRef.setData({}).then((_) {
      return true;
    }).catchError((error) {
      print('error in users list add user with ulid $ulid, uid $uid.');
      return false;
    });
  }

  static void removeUser(String ulid, String uid) async {
    usersListsCollection.document(ulid).collection("members").document(uid).delete();
  }

  static Future<UsersList> getUsersList(String ulid) async {
    UsersList usersList;

    // ref to doc in firestore database, may not exist
    DocumentReference ulReference = usersListsCollection.document(ulid);

    // the doc itself
    DocumentSnapshot ulSnapshot = await ulReference.get();

    if (ulSnapshot.exists) {
      List<String> members = [];
      try {
        // get all documents in sub-collection members
        QuerySnapshot result = await ulReference.collection('members').getDocuments();
        // query snapshot is a query result, may contain docs.
        for (int i = 0; i < result.documents.length; i++) {
          DocumentSnapshot uidDoc = result.documents[i];
          members.add(uidDoc.documentID);
        }
      } catch (e, s) {
        print(s);
      }

      usersList = UsersList.fromDatabase(ulid: ulReference.documentID, membersUids: members);
    } else {
      print('Tried to get nonexistent users list id ' + ulid);
    }

    return usersList;
  }
}
