import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/screens/group_creation/group_creation.dart';

class GroupCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Group'),
      ),
      body: GroupCreationBody(),
    );
  }
}
