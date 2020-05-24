import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/userProfile/mainUserProfilePage.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';
import 'package:teamapp/services/firestore/searchByName/searchUserByName.dart';


class SearchByName extends StatefulWidget {
  final User user;
  final SearchUserByName searchUserByName;
  final String title;
  SearchByName({this.user, this.searchUserByName, this.title});

  @override
  _SearchByNameState createState() => new _SearchByNameState();
}

class _SearchByNameState extends State<SearchByName> {
  var _queryResultSet = [];
  var _tempSearchStore = [];
  User user;
  @override
  void initState() {
    user = widget.user;
  }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        _queryResultSet = [];
        _tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (_queryResultSet.length == 0 && value.length == 1) {
      _queryResultSet = widget.searchUserByName.searchByName(value, currentUser: widget.user.uid);
    } else {
      _tempSearchStore = [];
      _queryResultSet.forEach((doc) {
        if (fullName(doc.data).startsWith(capitalizedValue)) {
          setState(() {
            _tempSearchStore.add(doc);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text(widget.title),
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.search),
                    iconSize: 20.0,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(height: 10.0),
          ListView(
              primary: false,
              shrinkWrap: true,
              children: _tempSearchStore.map((doc) {
                return buildResultCard(doc);
              }).toList())
        ]));
  }

  Widget buildResultCard(doc) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: InkWell(
        onTap: () {
          var userProfile = UserDataManager.createUserFromDoc(doc);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainUserProfilePage(user: userProfile)));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: doc.data['imageUrl'],
              child: CircleAvatar(
                backgroundImage: NetworkImage(doc.data['imageUrl']),
                radius: 30.0,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  fullName(doc.data),
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String fullName(var element) {
    return element['first_name'] + " " + element['last_name'];
  }


}
