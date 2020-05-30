import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/services/firestore/searchByName/searchUserByName.dart';

class UserSearchByName implements SearchUserByName {
  static final CollectionReference usersCollection =
      Firestore.instance.collection("users");

  @override
  List searchByName(String searchField, {currentUser}) {
    var _queryResultSet = [];
    searchByNameDocument(searchField).then((QuerySnapshot docs) {
      for (int i = 0; i < docs.documents.length; ++i) {
        _queryResultSet.add(docs.documents[i]);
      }
    });
    return _queryResultSet;
  }

  static searchByNameDocument(String searchField) {
    return usersCollection
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .getDocuments();
  }

  @override
  Future<List> getAll({currentUser}) {
    return null;
  }
}
