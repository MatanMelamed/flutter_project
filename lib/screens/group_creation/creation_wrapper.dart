import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/screens/group_creation/creation_form.dart';

class GroupCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Group'),
      ),
      body: GroupCreation(),
    );
  }

}