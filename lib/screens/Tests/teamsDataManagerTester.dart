import 'dart:io';

import 'package:flutter/material.dart';
import 'package:teamapp/models/storage_image.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/services/firestore/firestoreManager.dart';
import 'package:teamapp/services/general/utilites.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';

class Tries extends StatefulWidget {
  @override
  _TriesState createState() => _TriesState();
}

class _TriesState extends State<Tries> {
  File f;
  Team t;

  create() async {
    print('Creating objects');
    File file = await Utilities.loadImage("images/default_profile_img.png");
    Team team = Team.fromWithinApp(
        name: "TeamApp",
        description: "The best team of all!\nAll about snail racing!\nShare your knowledge of snails!",
        isPrivate: false,
        ownerUid: "007");

    team = await TeamDataManager.createTeam(team, file);

    setState(() {
      t = team;
    });
  }

  load() async {
    Team team = await TeamDataManager.getTeam("y6MsA6Trg0hri3OOxBfF");
    setState(() {
      t = team;
    });
  }

  replace() async {
    await load();
    File f = await Utilities.loadImage('images/team.jpg');
    await StorageManager.updateImage(f, StorageImage(url: t.imageUrl,path: t.imageRemotePath));
    load();
  }

  @override
  void initState() {
    //replace();
    load();
    //create();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: t == null
              ? Container(
                  child: Text('text'),
                )
              : Column(
                  children: <Widget>[
                    Text('Tid: ${t.tid}'),
                    Text('Image Url: ${t.imageUrl}'),
                    Text('Image Path: ${t.imageRemotePath}'),
                    Text('User Lists ID: ${t.ulid}'),
                    Text('Name: ${t.name}'),
                    Image(
                      image: NetworkImage(t.imageUrl),
                    ),
                    Text('Description: ${t.description}'),
                    Text('Is Private: ${t.isPrivate}'),
                    Text('Owner ID: ${t.ownerUid}'),
                  ],
                ),
        ),
      ),
    );
  }
}
