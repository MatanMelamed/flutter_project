import 'package:flutter/material.dart';
import 'package:teamapp/screens/Home/notifications_badge.dart';
import 'feed.dart';
import 'search.dart';
import 'create.dart';
import 'mainDrawer.dart';
import 'dart:async';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _notificationsCounter =0;
  StreamController<int> _notificationsController = StreamController<int>();

  final _pageOptions = [
    FeedPage(),
    SearchPage(),
    CreatePage()
  ];

  @override
  Widget build(BuildContext context) {
//    return StreamProvider.value(
//      value: UserDataManager(uid: widget.uid).user,
//      value: UserDataManager.getUser(widget.uid),
//    child: DefaultTabController(
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              title: Text("Title of the AppBar"),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
              actions: <Widget>[
                IconButton(
                  icon: StreamBuilder(
                    initialData: _notificationsCounter,
                    stream: _notificationsController.stream,
                    builder: (_, snapshot) => BadgeIcon(
                      icon: Icon(Icons.notifications, size: 25),
                      badgeCount: snapshot.data,
                    ),
                  ),
                  onPressed: (() {
                    print("notifications button clicked");
                    this._notificationsCounter=0;
                    _notificationsController.sink.add(_notificationsCounter);
                  }),
                ),
                IconButton(
                  icon: Icon(Icons.plus_one),
                  onPressed: (() {
                    setState(() {
                      this._notificationsCounter++;
                      _notificationsController.sink.add(_notificationsCounter);
                      print("increased notification");
                    });
                  }),

                )
              ],

              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: "Home",
                  ),
                  Tab(
                    text: "Search",
                  ),
                  Tab(
                    text: "Create",
                  )
                ],
              )
            ),
          drawer: MainDrawer(),
          body: TabBarView(
            children: _pageOptions,
          )
        ),
      );
  }
}