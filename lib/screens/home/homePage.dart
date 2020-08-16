import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/home/create.dart';
import 'dart:async';
import 'package:teamapp/screens/home/feed.dart';
import 'package:teamapp/screens/home/mainDrawer.dart';
import 'package:teamapp/screens/home/searchAndCreate.dart';

import 'notificationsPage.dart';
import 'notifications_badge.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentReference _notificationsDocument;

  final _pageOptions = [
    FeedPage(),
    SearchPage(),
//    CreatePage()
  ];


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    _notificationsDocument =   Firestore.instance
        .collection("notifications")
        .document(user.uid);

    return SafeArea( // Optional !!
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
                title: Text("TeamApp", style: TextStyle(fontFamily: 'Signatra',fontSize: 47),),
                centerTitle: true,
                backgroundColor: Theme.of(context).primaryColor,
                actions: <Widget>[
                  IconButton(
                    icon: StreamBuilder<DocumentSnapshot>(
//                      initialData: _notificationsCounter,
//                      stream: _notificationsController.stream,
                      stream: _notificationsDocument.snapshots(),
                      builder: (context, snapshot) => BadgeIcon(
                        icon: Icon(Icons.notifications, size: 25),
                        badgeCount: getBadgeCount(snapshot),
                      ),
                    ),
                    onPressed: (() {
                      print("notifications button clicked");
                      _notificationsDocument.setData({'new_counter':0});
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NotificationsPage(user.uid)));
                    }),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],

                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      text: "Home",
                    ),
                    Tab(
                      text: "Search & Create",
                    ),
//                    Tab(
//                      text: "Create",
//                    )
                  ],
                )
              ),
            drawer: MainDrawer(),
            body: TabBarView(
              children: _pageOptions,
            )
          ),
        ),
    );
  }

  int getBadgeCount(AsyncSnapshot asyncDocSnapshot) {
    if (!asyncDocSnapshot.hasData) {
      return 0;
    }
    DocumentSnapshot documentSnapshot = asyncDocSnapshot.data;
    if (!documentSnapshot.exists) {
      return 0;
    }
    if (documentSnapshot.data != null) {
      return documentSnapshot.data['new_counter'];
    }
    return 0;
  }
}

