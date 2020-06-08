import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/notification/notification.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/services/firestore/notifications/baseNotificationManager.dart';

class FriendNotificationManager {
  static final CollectionReference _notificationsRef =
      Firestore.instance.collection("notifications");

  static Future<void> sendFriendReqNotification(
      String userId, String otherId) async {
    Notification n = Notification(
        type: 'addFriendNotification',
        metadata: {
          'viewed': false,
          'fromID': userId,
        });
    // store the notification in the other's user collection
    await BaseNotificationManager.createNotification(otherId, userId, n);
    sleep(const Duration(seconds: 1)); //flutter updates a doc once per second
    await BaseNotificationManager.increaseNewCounter(otherId);
  }

  static Future<void> deleteFriendNotification(
      String userId, String otherId) async {
    //delete the notification for OTHER User
    bool _status =
        await BaseNotificationManager.deleteNotification(otherId, userId);
    sleep(const Duration(
        seconds: 1)); //flutter can update a doc ONLY once per second
    if (_status) await BaseNotificationManager.decreaseNewCounter(otherId);
    sleep(const Duration(
        seconds: 1)); //flutter can update a doc ONLY once per second

    //delete the notification for ONLINE User
    _status = await BaseNotificationManager.deleteNotification(userId, otherId);
    sleep(const Duration(
        seconds: 1)); //flutter can update a doc ONLY once per second
    if (_status) await BaseNotificationManager.decreaseNewCounter(userId);
  }

  static Future<void> acceptFriendNotification(
      String userId, String otherId) async {
    // create accepted friend notification for Other user
    Notification otherN = Notification(
        type: 'acceptedFriendNotification',
        metadata: {
          'viewed': false,
          'fromID': userId,
        });
    await BaseNotificationManager.createNotification(otherId, userId, otherN);
    sleep(const Duration(
        seconds: 1)); //flutter can update a doc ONLY once per second
    await BaseNotificationManager.increaseNewCounter(otherId);
    sleep(const Duration(
        seconds: 1)); //flutter can update a doc ONLY once per second

    // create accepted friend notification for Online user
    Notification userN = Notification(
        type: 'acceptedFriendNotification',
        metadata: {
          'viewed': false,
          'fromID': otherId,
        });
    await BaseNotificationManager.createNotification(userId, otherId, userN);
    sleep(const Duration(
        seconds: 1)); //flutter can update a doc ONLY once per second
    await BaseNotificationManager.increaseNewCounter(userId);
  }
}
