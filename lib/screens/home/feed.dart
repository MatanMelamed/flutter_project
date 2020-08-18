import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/services/general/location.dart';
import 'package:teamapp/widgets/general/future_list.dart';
import 'package:teamapp/widgets/loading.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final List<EntryInfo> _entries = <EntryInfo>[];
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    addEntries(8);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        addEntries(7);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GeoPoint>(
      future: LocationService.getCurrentLocationGeoPoint(),
        builder: (context, AsyncSnapshot<GeoPoint> locationSnapshot){
          if(locationSnapshot.hasData){
            return new Scaffold(
                body: FutureList(
                    50,
                    locationSnapshot.data,
                    DateTime.now(),
                    DateTime.now().add(new Duration(days: 14)),
                    "Aerobic-CrossFit BallSport-BasketBall BodyBuilding-WeightLifting",
                    "meeting you may like.."
                )
            );
          }
          return Loading();
        }
    );
  }

  //TO CHANGE
  void addEntries(int n) {
    int counter = 0;
    for (int i = 0; i < n; i++) {
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
