import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/friend/searchByName.dart';
import 'package:teamapp/services/firestore/searchByName/userSearchByName.dart';

class SearchUsers extends StatefulWidget {

  @override
  _SearchUsersState createState() => new _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: true);
    return new Scaffold(
        appBar: new AppBar(
          title: Text('Search New Friend'),
        ),
        body: SearchByName(
          user: user, searchUserByName: UserSearchByName(), showAll: false,)
    );
  }
}
