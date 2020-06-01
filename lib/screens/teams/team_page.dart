import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/archive/page_transitions.dart';
import 'package:teamapp/screens/chat/chat.dart';
import 'package:teamapp/screens/teams/team_options.dart';
import 'package:teamapp/widgets/general/diamond_image.dart';
import 'package:teamapp/widgets/general/editViewImage.dart';
import 'package:teamapp/widgets/general/narrow_returnbar.dart';

class TeamPage extends StatefulWidget {
  final Team team;

  TeamPage({this.team});

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> with TickerProviderStateMixin {
  bool isAdmin;

  @override
  void initState() {
    super.initState();
    isAdmin = widget.team.ownerUid == "C5h3rKCR9Rh7qbGmfc3didEuZlu1";
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double top = MediaQuery.of(context).padding.top;

    return Scaffold(
      //appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: height - top,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GetNarrowReturnBar(context),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 35),
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 25),
                      DiamondImage(
                        size: 110,
                        imageProvider:
                            NetworkImage(widget.team.remoteImage.url),
                        heroTag: "teamProfileImage",
                        callback: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditViewImage(
                              imageProvider:
                                  NetworkImage(widget.team.remoteImage.url),
                              onSaveNewImageFile: (file) {},
                              heroTag: "teamProfileImage",
                              mode: isAdmin
                                  ? EditViewImageMode.ViewAndEdit
                                  : EditViewImageMode.ViewOnly,
                            );
                          }));
                        },
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: GestureDetector(
                          onTap: () {
                            print('team options clicked');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    TeamOptionsPage(team: widget.team)));
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 13),
                            child: SvgPicture.asset(
                              "assets/icons/options-halved.svg",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(top: 10, left: 5),
                              child: Text(
                                widget.team.name,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 85,
                              padding: const EdgeInsets.only(
                                  top: 10, left: 0, right: 3),
                              child: Text(
                                widget.team.description,
                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DefaultTabController(
                  length: 2,
                  child: Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white70, width: 2),
                            color: Colors.blue[400],
                          ),
                          //color: Colors.blue[400],
                          child: TabBar(
                            indicator: BoxDecoration(
                              //color: Colors.transparent,
                              color: Colors.white38,
                              //border: Border.all(color: Colors.black87, width: 2),
                            ),
                            indicatorColor: Colors.orange,
                            tabs: <Widget>[
                              Tab(
                                  child: Text('Meetups',
                                      style: TextStyle(fontSize: 18))),
                              Tab(
                                  child: Text('Messages',
                                      style: TextStyle(fontSize: 18))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: <Widget>[
                              Container(
                                height: 200,
                                color: Colors.lightBlueAccent[100],
                              ),
                              Container(
                                height: 200,
                                color: Colors.white,
                                child: Chat(
                                  user: Provider.of<User>(context),
                                  team: widget.team,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
