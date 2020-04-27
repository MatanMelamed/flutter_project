import 'package:flutter/material.dart';
import 'package:teamapp/models/group.dart';

class GTester extends StatefulWidget {
  @override
  _GTesterState createState() => _GTesterState();
}

class _GTesterState extends State<GTester> {

  Group g = Group.fromWithinApp(membersUids: ['','','']);
  

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
