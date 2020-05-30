import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/friend/searchByName.dart';
import 'package:teamapp/screens/friend/searchUsers.dart';
import 'package:teamapp/services/firestore/searchByName/friendSearchByName.dart';

class SearchFriends extends StatefulWidget {
  @override
  _SearchFriendsState createState() => new _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: true);
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Friends'),
        actions :<Widget>[ IconButton(
          tooltip: 'Add New Friends',
          icon: Icon(Icons.add_circle, size: 40.0,),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchUsers()));
          },
        )],
      ),
      body: SearchByName(user: user, searchUserByName: FriendSearchByName(), showAll: true,)
    );
  }
}
