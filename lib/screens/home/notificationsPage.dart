import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/notification/acceptedFriendNotification.dart';
import 'package:teamapp/models/notification/addFriendNotification.dart';
import 'package:teamapp/models/notification/notification.dart' as base;
import 'package:teamapp/models/user.dart';
import 'package:teamapp/widgets/loading.dart';
import 'package:teamapp/services/firestore/notifications/friendNotificationsManager.dart';

class NotificationsPageBuilder extends StatefulWidget {
  final List<base.Notification> notificationsList;

  NotificationsPageBuilder(this.notificationsList);

  @override
  _NotificationsPageBuilderState createState() =>
      _NotificationsPageBuilderState();
}


class _NotificationsPageBuilderState extends State<NotificationsPageBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
          primary: false,
          shrinkWrap: true,
          children: widget.notificationsList.map<Widget>((base.Notification n) {
            return n.getWidget(context);
          }).toList()),
    );
  }
}




class NotificationsPage extends StatelessWidget {
  final String userId;
  final Map<String, base.Notification> typeToNotification =
      initNotificationsMap();

  NotificationsPage(this.userId);

  @override
  Widget build(BuildContext context) {
    log("building notifications page...");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          centerTitle: true,
        ),
        body: FutureBuilder<List<base.Notification>>(
            future: initPage(),
            builder:
                (context, AsyncSnapshot<List<base.Notification>> snapshot) {
              if (snapshot.hasData) {
                log("Done Loading notifications");
                return NotificationsPageBuilder(snapshot.data.toList());
              } else {
                log("Loading....");
                return Loading();
              }
            }),
      ),
    );
  }
  static Map<String, base.Notification> initNotificationsMap() {
    Map<String, base.Notification> typeToNotification = {
      'addFriendNotification': (() => AddFriendNotification())(),
      'acceptedFriendNotification': (() => AcceptedFriendNotification())(),
    };
    return typeToNotification;
  }

//TODO: refactor to use then (like getAll and remove logs)
  Future<List<base.Notification>> initPage() async {
    List<base.Notification> notificationsList = [];
    DocumentReference _userNotDoc =
        Firestore.instance.collection("notifications").document(userId);

    //returns a Future<QuerySnapshot> (Contains list of doc snapshots)
    QuerySnapshot query = await _userNotDoc
        .collection("userNotifications").orderBy('timestamp',descending: true).limit(60)
        .getDocuments()
        .catchError((error) {
      log("cant get documents for online user");
    });

    List<DocumentSnapshot> docs = query.documents;
    log("number of notifications pulled:" + docs.length.toString());
    for (int i = 0; i < docs.length; ++i) {
      DocumentSnapshot doc = docs[i];
      Timestamp timestamp = doc.data['timestamp'];
      var metadata = doc.data['metadata'];
      // create Notification object from Map according to type

      base.Notification n = typeToNotification[doc.data['type']];

      await n.handleMapFromDB(timestamp,metadata);
      notificationsList.add(n);
    }
    log("number of Notification objects created:" +
        notificationsList.length.toString());
    return notificationsList;
  }
}


//
//class NotificationsPag extends StatefulWidget {
//  @override
//  _NotificationsPagState createState() => _NotificationsPagState();
//}
//
//class _NotificationsPagState extends State<NotificationsPag> {
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    log("building notifications page ");
//    return SafeArea(
//      child: Scaffold(
//        appBar: AppBar(
//          title: Text('Notifications'),
//          centerTitle: true,
//        ),
//        body: FutureBuilder<List<base.Notification>>(
//            future: initPage(),
//            builder:
//                (context, AsyncSnapshot<List<base.Notification>> snapshot) {
//              if (snapshot.hasData) {
//                log("Done Loading notifications");
//                log("SIZE OF LIST 3:" + snapshot.data.toList().length.toString());
//                return NotificationsPageBuilder(snapshot.data.toList());
//              } else {
//                log("Loading....");
//                return Loading();
//              }
//            }),
//      ),
//    );
//  }
//
//
//
//
//
//  //TODO: refactor to use then (like getAll and remove logs)
//  Future<List<base.Notification>> initPage() async {
//    List<base.Notification> notificationsList = [];
//    log("SIZE OF LIST 1 :" + notificationsList.length.toString());
//    DocumentReference _userNotDoc =
//    Firestore.instance.collection("notifications").document(userId);
//
//    //returns a Future<QuerySnapshot> (Contains list of doc snapshots)
//    QuerySnapshot query = await _userNotDoc
//        .collection("userNotifications").orderBy('timestamp',descending: true).limit(60)
//        .getDocuments()
//        .catchError((error) {
//      log("cant get documents for online user");
//    });
//
//    List<DocumentSnapshot> docs = query.documents;
//    log("number of notifications pulled:" + docs.length.toString());
//    for (int i = 0; i < docs.length; ++i) {
//      DocumentSnapshot doc = docs[i];
//      Timestamp timestamp = doc.data['timestamp'];
//      var metadata = doc.data['metadata'];
//      // create Notification object from Map according to type
//
//      log("In getNot. value from map for key 'type': " +
//          typeToNotification[doc.data['type']].toString()); //TODO:REMOVE
//
//      base.Notification n = typeToNotification[doc.data['type']];
//      log("In getNot." + n.toString()); //TODO:REMOVE
//
//      await n.handleMapFromDB(timestamp,metadata);
//      log("returned from mapFromDB");
//      notificationsList.add(n);
//    }
//    log("number of Notification objects created:" +
//        notificationsList.length.toString());
//    log("SIZE OF LIST 2 :" + notificationsList.length.toString());
//    return notificationsList;
//  }
//
//
//
//}
