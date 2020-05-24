//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'file:///C:/Users/Eden/AndroidStudioProjects/flutter_project/lib/services/firestore/searchByName/searchUserByName.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';

class FriendDataManager{
  static final CollectionReference _friendRequestRef =
      Firestore.instance.collection("friendsRequest");
  static final CollectionReference _friendRef =
      Firestore.instance.collection("friends");
  String _currentStatus;
  String userId;
  String otherId;
  final String _requestType = 'request_type';

  FriendDataManager({this.userId, this.otherId});

  Future<String> getStatus() async {

    DocumentSnapshot documentFriendSnapshot = await _friendRef
        .document(userId)
        .collection("userFriends")
        .document(otherId)
        .get();
    if (documentFriendSnapshot.exists)
      _currentStatus = "friend";
    else {
      DocumentSnapshot documentSnapshot = await _friendRequestRef
          .document(userId)
          .collection("userFriendsRequest")
          .document(otherId)
          .get();

      if (documentSnapshot.exists) {
        _currentStatus = documentSnapshot.data[_requestType];
      } else {
        _currentStatus = "no_friend";
      }
    }
    return _currentStatus;
  }

  Future<void> unFriend() async {

     _friendRef.document(userId)
        .collection("userFriends")
        .document(otherId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    _friendRef.document(otherId)
        .collection("userFriends")
        .document(userId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    _currentStatus = "no_friend";
  }

  Future<void> sendFriendRequest() async{

    _friendRequestRef
        .document(userId)
        .collection("userFriendsRequest")
        .document(otherId)
        .setData(
        {
          _requestType : "send"
        }
        );

    _friendRequestRef
        .document(otherId)
        .collection("userFriendsRequest")
        .document(userId)
        .setData(
        {
          _requestType : "request"
        }
    );

    _currentStatus = "send";
  }

  Future<void> cancelRequest() async{
    _friendRequestRef.document(userId)
        .collection("userFriendsRequest")
        .document(otherId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    _friendRequestRef.document(otherId)
        .collection("userFriendsRequest")
        .document(userId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    _currentStatus = "no_friend";
  }

  Future<void> acceptFriend() async{

    await cancelRequest();

    _friendRef
        .document(userId)
        .collection("userFriends")
        .document(otherId)
        .setData(
        {
          "date" : DateTime.now().toIso8601String()
        }
    );

    _friendRef
        .document(otherId)
        .collection("userFriends")
        .document(userId)
        .setData(
        {
          "date" : DateTime.now().toIso8601String()
        }
    );

  }


}
