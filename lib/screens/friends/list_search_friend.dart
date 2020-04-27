import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user_data.dart';
import 'package:teamapp/screens/friends/user_tile.dart';
class ListSearchFriend extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ListSearchFriendState();
}

class _ListSearchFriendState extends State<ListSearchFriend>{
  @override
  Widget build(BuildContext context) {
    var all_user = Provider.of<List<UserData>>(context);
    return ListView.builder(
      itemCount: all_user.length,
      itemBuilder: (context, index){
        return UserTile(user: all_user[index]);
      },
    );
  }


  
}