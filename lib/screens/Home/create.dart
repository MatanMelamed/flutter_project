import 'package:flutter/material.dart';
import 'package:teamapp/screens/group_creation/creation_wrapper.dart';
import 'package:teamapp/widgets/general/ExpandedHomeCard.dart';

class CreatePage extends StatelessWidget {
  VoidCallback _navigationPush(BuildContext context, Widget page) {
    return () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ExpandedHomeCard(
            title: "Create Group",
            description: "some description on creation of group",
            // TODO: find a good image.
            trailImageUrl: "assets/images/three_friends_play.png",
            onTap: _navigationPush(context, GroupCreationPage()),
          ),
          ExpandedHomeCard(
            title: "Create one time meeting",
            description: "Some description on one time meeating",
            // TODO: find a good image.
            trailImageUrl: "assets/images/three_friends_play.png",
            onTap: _navigationPush(context, GroupCreationPage()),
          )
        ],
      ),
    );
  }
}
