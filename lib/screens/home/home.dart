import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/archive/page_transitions.dart';
import 'package:teamapp/screens/home/create.dart';
import 'package:teamapp/screens/home/feed.dart';
import 'package:teamapp/screens/home/mainDrawer.dart';
import 'package:teamapp/screens/home/notifications.dart';
import 'package:teamapp/screens/home/search.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';

class Home extends StatelessWidget {
  final AuthService _authService = AuthService();

  int notificationsCounter =0;
  final _pageOptions = [
    FeedPage(),
    SearchPage(),
    CreatePage()
  ];

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
              title: Text("Title of the AppBar"),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications),
                  color: Colors.white,
                  onPressed: () {
                    print("notifications clicked");
                    Navigator.of(context).push(createRoute(NotificationsPage()));
                  },
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
