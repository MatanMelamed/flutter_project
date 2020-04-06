import 'package:flutter/material.dart';

class MyFeedWindow extends StatefulWidget {
  @override
  _MyFeedWindowState createState() => _MyFeedWindowState();
}

class _MyFeedWindowState extends State<MyFeedWindow> {
  final List<EntryInfo> _entries = <EntryInfo>[];
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    addEntries(7);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        addEntries(7);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: new ListView.builder(
      controller: _scrollController,
      itemCount: _entries.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(Icons.person),//Category
          title: Text(_entries[index].title),
          subtitle: Text(_entries[index].description),
          trailing: Icon(Icons.unfold_more),
          isThreeLine: true,
          selected: false,
          dense: true,
        );
      },
    ));
  }


  //TO CHANGE
  void addEntries(int n) {
    int counter =0;
    for (int i=0; i< n; i++) {
      counter++;
      EntryInfo e = new EntryInfo();
      e.title = "Hi TeamApp " + counter.toString();
      e.description = "Hi TeamApp";
      e.category = "Hi TeamApp";
        _entries.add(e);
      setState(() {});
    }
  }



  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class EntryInfo {
  String title;
  String description;
  String category;
}
