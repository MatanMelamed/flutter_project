
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/notification/notification.dart';



class BaseNotificationManager {
  static final CollectionReference _notificationsCollection =
  Firestore.instance.collection("notifications");

  static Future<bool> createNotification(String userId, String otherId,Notification n) async {
    DocumentReference userDocRef = _notificationsCollection.document(userId)
        .collection("userNotifications")
        .document(otherId);
    userDocRef.setData({
      'type': n.type.toString(),
      'timestamp': DateTime.now(),
      'metadata': n.metadata,
    }).then((_) {
      log("new notification was sent to $userId");
      return true;
    }).catchError((error) {
      print(error);
      print(
          'error adding new notification. documentID: $otherId , in user:$userId , with type: ${n.type} , and metadata: ${n.metadata}');
      return false;
    });
  }

  static Future<bool> deleteNotification(String userId, String otherId) async {
    bool _status = false;
    DocumentSnapshot docSnapshot = await _notificationsCollection.document(userId)
        .collection("userNotifications")
        .document(otherId).get();

    if (docSnapshot.exists) {
      await docSnapshot.reference.delete().catchError((error) {
        print(error);
        print(
            'error deleting notification. documentID: $otherId , in user:$userId ');
      });
      log("new notification of $userId with id: $otherId was deleted");
      _status =true;
    }
    log("returning status=" + _status.toString());
    return _status;
  }


  static Future<void> increaseNewCounter(String userId) async {
    _notificationsCollection.document(userId).setData({'new_counter': FieldValue.increment(1)});
    log("increased $userId new_counter by 1");
  }

  static Future<void> decreaseNewCounter(String userId) async {
    _notificationsCollection.document(userId).get().then((doc) {
      if (doc.data['new_counter'] > 1) {
        _notificationsCollection.document(userId).updateData({'new_counter': FieldValue.increment(-1)});
        log("decreased $userId new_counter by 1");
      } else {
        _notificationsCollection.document(userId).setData({'new_counter': 0});
        log("decreased $userId new_counter to 0");
      }
    });
  }

}