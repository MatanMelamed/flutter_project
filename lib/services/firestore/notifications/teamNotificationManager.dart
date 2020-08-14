import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/notification/notification.dart';

class TeamNotificationManager {
  static final CollectionReference _notificationsCollection =
  Firestore.instance.collection("notifications");

  static Future<void> sendTeamNotifications(String leaderId,
      List<String> memberIds, String teamId) async {
    Notification n = Notification(
        type: 'addedToTeamNotification',
        metadata: {
          'viewed': false,
          'teamId': teamId,
        });

    memberIds.forEach((String memberId) {
      if (memberId != leaderId) {
        sendTeamNotificationToUser(memberId, teamId,n);
      }
    });
  }

  static Future<void> sendTeamNotificationToUser(String memberId,
      String teamId, Notification n) async {
    DocumentReference teamDocRef = _notificationsCollection.document(
        memberId).collection("teamNotifications").document(teamId);

    teamDocRef.setData({
      'type': n.type,
      'timestamp': DateTime.now(),
      'metadata': n.metadata,
    }).then((_) {
      log("new Team notification was sent to $memberId");
      return true;
    }).catchError((error) {
      print(error);
      print(
          'error adding new notification. documentID: $teamId , in user:$memberId , with type: ${n
              .type} , and metadata: ${n.metadata}');
    });
    _notificationsCollection.document(memberId).setData({'new_counter': FieldValue.increment(1)}).then((_) {
      log("increased $memberId new_counter by 1");
    });

  }


}