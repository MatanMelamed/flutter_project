import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/notification/acceptedFriendNotification.dart';
import 'package:teamapp/models/notification/addFriendNotification.dart';
import 'package:teamapp/models/notification/addedToTeamNotification.dart';
import 'package:teamapp/models/notification/notification.dart' as base;
import 'package:teamapp/widgets/loading.dart';

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


typedef base.Notification lambda();

class NotificationsPage extends StatelessWidget {
  final String userId;
  final Map<String,  lambda> typeToNotification =
      initNotificationsMap();

  NotificationsPage(this.userId);

  @override
  Widget build(BuildContext context) {
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

  static Map<String, lambda> initNotificationsMap() {
    Map<String, lambda> typeToNotification = {
      'addFriendNotification': () => AddFriendNotification(),
      'acceptedFriendNotification': (() => AcceptedFriendNotification()),
      'addedToTeamNotification': (() => AddedToTeamNotification()),
    };
    return typeToNotification;
  }

//TODO: refactor to use then (like getAll and remove logs)
  Future<List<base.Notification>> initPage() async {
    List<base.Notification> notificationsList = [];
    DocumentReference userNotDoc =
        Firestore.instance.collection("notifications").document(userId);

    QuerySnapshot userN =  await userNotDoc.collection("userNotifications").getDocuments();
    QuerySnapshot teamN =  await userNotDoc.collection("teamNotifications").getDocuments();

    List<DocumentSnapshot> docs = [];
    docs.addAll(userN.documents);
    docs.addAll(teamN.documents);

    docs.sort((a,b) {
      Timestamp adate = a.data['timestamp'];
      Timestamp bdate = b.data['timestamp'];
      return bdate.compareTo(adate);
  });

    for (int i = 0; i < docs.length; ++i) {
      DocumentSnapshot doc = docs[i];
      Timestamp timestamp = doc.data['timestamp'];
      var metadata = doc.data['metadata'];
      // create Notification object from Map according to type
      base.Notification n = typeToNotification[doc.data['type']]();

      bool exist = await n.handleMapFromDB(timestamp,metadata);
      if (exist) {
        notificationsList.add(n);
      }
    }
    return notificationsList;
  }
}