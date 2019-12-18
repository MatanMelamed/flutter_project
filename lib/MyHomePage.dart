import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    );
  }

  String getUserName() {
    //Go To local DB
    return "Eyal";
  }
}


class MyFeedWindow extends StatefulWidget {
  @override
  _MyFeedWindowState createState() => _MyFeedWindowState();
}

class _MyFeedWindowState extends State<MyFeedWindow> {
  final List<String> _listOf = <String>["פגישה ב20.12.2019 בשעה 16:00 במגרש של הפועל מחנה יהודה", "פגישה ב21.12.2019 במגרש הטניס","1","2","3","4","5","6","7","8","9","10","11"]; //list of saved  words

  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: new ListView.builder(
      itemBuilder: (_, int index) {
//      if (index >= _listOf.length) {
//        _listOf.addAll(_listOf().take(10));
//      }
        return _buildRow(_listOf[index]);
      }, itemCount: _listOf.length,
      scrollDirection: Axis.vertical,
        ));
  }

  Widget _buildRow(String word) {
    return ListTile(title: Text(word), trailing: Icon(Icons.expand_more));
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
