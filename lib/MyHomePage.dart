import 'package:flutter/material.dart';
import 'feed.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _bottomNavidationIndex =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Center(
            child: new Text("Hello " + getUserName() + "!",
                style: TextStyle(fontSize: 20)),
          ),
          backgroundColor: Colors.lightGreen),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[MenuBar(), MyFeedWindow()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavidationIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            backgroundColor: Colors.deepPurpleAccent
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text("Seach group"),
              backgroundColor: Colors.green
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.create),
              title: Text("Create group"),
              backgroundColor: Colors.red
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text("Notifications"),
              backgroundColor: Colors.blue
          )
        ],
        onTap: (index) {
          setState(() {
            _bottomNavidationIndex = index;
          });
        },
      ),
    );
  }

  String getUserName() {
    //Go To local DB
    return "Eyal";
  }
}


class MenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: <Widget>[
          new Column(
            children: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.green,
                  ),
                  iconSize: 70,
                  onPressed: null),
              //CAN ADD CONTAINER TO WRAP TEXT IF NEEDED
              Text(
                "Search \n Group",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          new Column(
            children: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.create,
                    color: Colors.blue,
                  ),
                  iconSize: 70,
                  onPressed: null),
              //CAN ADD CONTAINER TO WRAP TEXT IF NEEDED
              Text(
                "Create \n Group",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          new Column(
            children: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.notification_important,
                    color: Colors.red,
                  ),
                  iconSize: 70,
                  onPressed: null),
              //CAN ADD CONTAINER TO WRAP TEXT IF NEEDED
              Text(
                "Notifications",
                style: TextStyle(fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }
}
