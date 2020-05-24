import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/friend/searchByName.dart';
import 'package:teamapp/services/firestore/searchByName/friendSearchByName.dart';

class SearchFriends extends StatefulWidget {
  @override
  _SearchFriendsState createState() => new _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: true);
    return SearchByName(user: user, searchUserByName: FriendSearchByName(), title: 'Friends',);
  }
}
