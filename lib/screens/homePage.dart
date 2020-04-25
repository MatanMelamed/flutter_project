import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/archive/page_transitions.dart';
import 'package:teamapp/services/database/user_management.dart';
import 'feed.dart';
import 'search.dart';
import 'create.dart';
import 'notifications.dart';
import 'mainDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int notificationsCounter =0;
  final _pageOptions = [
    FeedPage(),
    SearchPage(),
    CreatePage()
  ];

  @override
  Widget build(BuildContext context) {
    print("context home:" + context.toString());
    final user = Provider.of<User>(context);
    return StreamProvider.value(
      value: UserManagement(uid: user.uid).user,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
//            title: Center(
//              child: new Text("Hello " + getUserName() + "!",
//                  style: TextStyle(fontSize: 20)),
//            ),
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
      ),
    );
  }
}

//class MenuBar extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: new Row(
//        mainAxisSize: MainAxisSize.max,
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: <Widget>[
//          new Column(
//            children: <Widget>[
//              new IconButton(
//                  icon: Icon(
//                    Icons.search,
//                    color: Colors.green,
//                  ),
//                  iconSize: 70,
//                  onPressed: null),
//              //CAN ADD CONTAINER TO WRAP TEXT IF NEEDED
//              Text(
//                "Search \n Group",
//                style: TextStyle(fontSize: 15),
//              )
//            ],
//          ),
//          new Column(
//            children: <Widget>[
//              new IconButton(
//                  icon: Icon(
//                    Icons.create,
//                    color: Colors.blue,
//                  ),
//                  iconSize: 70,
//                  onPressed: null),
//              //CAN ADD CONTAINER TO WRAP TEXT IF NEEDED
//              Text(
//                "Create \n Group",
//                style: TextStyle(fontSize: 15),
//              )
//            ],
//          ),
//          new Column(
//            children: <Widget>[
//              new IconButton(
//                  icon: Icon(
//                    Icons.notification_important,
//                    color: Colors.red,
//                  ),
//                  iconSize: 70,
//                  onPressed: null),
//              //CAN ADD CONTAINER TO WRAP TEXT IF NEEDED
//              Text(
//                "Notifications",
//                style: TextStyle(fontSize: 15),
//              )
//            ],
//          )
//        ],
//      ),
//    );
//  }
//}
