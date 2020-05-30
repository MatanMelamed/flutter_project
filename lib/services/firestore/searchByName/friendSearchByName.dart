import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/services/firestore/searchByName/searchUserByName.dart';
import 'package:teamapp/services/firestore/searchByName/userSearchByName.dart';

class FriendSearchByName implements SearchUserByName {
  static final CollectionReference _friendRef =
      Firestore.instance.collection("friends");

  List searchByName(String searchField, {currentUser}) {
    var _queryResultSet = [];
    var friend = _friendRef.document(currentUser).collection('userFriends');
    UserSearchByName.searchByNameDocument(searchField)
        .then((QuerySnapshot docs) async {
      for (int i = 0; i < docs.documents.length; ++i) {
        DocumentSnapshot documentFriendSnapshot =
            await friend.document(docs.documents[i].documentID).get();
        if (documentFriendSnapshot.exists)
          _queryResultSet.add(docs.documents[i]);
      }
    });
    return _queryResultSet;
  }

  @override
  Future<List> getAll({currentUser}) async {
    var _queryResultSet = [];
    var friend = _friendRef.document(currentUser).collection('userFriends');
    return UserSearchByName.usersCollection
        .getDocuments()
        .then((QuerySnapshot docs) async {
      for (int i = 0; i < docs.documents.length; ++i) {
        DocumentSnapshot documentFriendSnapshot =
            await friend.document(docs.documents[i].documentID).get();
        if (documentFriendSnapshot.exists)
          _queryResultSet.add(docs.documents[i]);
      }
    }).then((value) => _queryResultSet);
  }
}
