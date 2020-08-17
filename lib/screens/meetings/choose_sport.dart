import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/sport.dart';
import 'package:teamapp/services/firestore/sportsDataManager.dart';
import 'package:teamapp/widgets/loading.dart';

class ChooseSportType extends StatefulWidget {
  @override
  _ChooseSportTypeState createState() => _ChooseSportTypeState();
}

class _ChooseSportTypeState extends State<ChooseSportType> {
  var checked = Map();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Sport>>(
      future: SportsDataManager.getAllSports(),
      builder: (context, AsyncSnapshot<List<Sport>> snapshot) {
        if (snapshot.hasData) {
          return buildBody(snapshot.data);/*new Scaffold(
            appBar: new AppBar(
              title: Text('choose sport type'),
            ),
            body: Column(
              children: <Widget>[
                ListView(
                    primary: false,
                    shrinkWrap: false,
                    children: snapshot.data.map((sportOption) {
                      var sport = convertSportToString(sportOption);
                      checked[sport] = false;
                      return buildResultCard(sport);
                    }).toList()),
                RaisedButton(
                  onPressed: () => print("sending to backend"),
                  child: Text("SEND"),
                )
                /* Container(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    onPressed: () {
                      String ans = '';
                      checked.forEach((key, value) {
                        if (value) {
                          ans += key;
                          ans += ' ';
                        }
                      });
                      Navigator.of(context).pop(ans);
                    },
                    color: Colors.blueAccent,
                    child: Text(
                      "choose !",
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.3,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                )*/
              ],
            ),
          );*/
        } else {
          return Loading();
        }
      },
    );
  }

  Widget buildBody(List<Sport> allSportType) {
    return Scaffold(
      appBar: AppBar(
        title: Text("choose sport type"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: allSportType.length,
            itemBuilder: (BuildContext context, int index) {
              var item = allSportType[index];
              var descripe = convertSportToString(item);
              if(!checked.containsKey(descripe))
                checked[descripe] = true;
              return CheckboxListTile(
                    title: Text(descripe),
                    value: checked[descripe],
                    onChanged: (val) {
                      setState(() {
                        checked[descripe] = val;
                      });
                    },
                  );
            },
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              onPressed: () {
                String ans = '';
                checked.forEach((key, value) {
                  if (value) {
                    ans += key;
                    ans += ' ';
                  }
                });
                Navigator.of(context).pop(ans);
              },
              color: Colors.blueAccent,
              child: Text(
                "choose !",
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.3,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget buildResultCard(String sportOption) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: CheckboxListTile(
          title: Text(sportOption),
          secondary: Icon(Icons.child_care),
          controlAffinity: ListTileControlAffinity.platform,
          value: checked[sportOption],
          onChanged: (bool value) {
            setState(() {
              print(value.toString() + " " + sportOption);
              checked[sportOption] = value;
            });
          },
          activeColor: Colors.blueAccent,
          checkColor: Colors.greenAccent,
        ));
  }

  String convertSportToString(Sport sport) {
    var sportType = sport.type.toString();
    sportType = sportType.split(".")[1];
    var subSport = sport.sport.toString();
    subSport = subSport.split(".")[1];
    return sportType + "-" + subSport;
  }
  

}
