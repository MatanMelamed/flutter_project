import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendsSuggester {
  static Future<List<DocumentSnapshot>> getFriendsSuggestions(
      String id, String query) async {
    if (query == '' || query == null) {
      return null;
    }

    QuerySnapshot withPrefixes = await Firestore.instance
        .collection("users")
        .where('searchKey', isEqualTo: query.substring(0, 1).toUpperCase())
        .getDocuments();

    CollectionReference _userFriends = Firestore.instance
        .collection("friends")
        .document(id)
        .collection('userFriends');

    List<DocumentSnapshot> suggestions = List();
    for (DocumentSnapshot doc in withPrefixes.documents) {
      var friend = await _userFriends.document(doc.documentID).get();
      if (friend.exists) {
        var name = nameOf(doc).toUpperCase();
        if (name.startsWith(query.toUpperCase())) suggestions.add(doc);
      }
    }

    return suggestions;
  }

  static String nameOf(DocumentSnapshot doc, {bool upperCase = false}) {
    var name = '${doc.data["first_name"]} ${doc.data["last_name"]}';
    return upperCase ? name.toUpperCase() : name;
  }

  static NetworkImage imageOf(DocumentSnapshot doc) =>
      NetworkImage(doc.data['imageUrl']);
}
