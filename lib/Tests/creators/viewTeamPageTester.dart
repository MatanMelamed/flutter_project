import 'package:flutter/material.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/screens/teams/team_add_user.dart';
import 'package:teamapp/screens/teams/team_page.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';

class ViewTeamPageTester extends StatefulWidget {
  @override
  _ViewTeamPageTesterState createState() => _ViewTeamPageTesterState();
}

class _ViewTeamPageTesterState extends State<ViewTeamPageTester> {
  Team team;

  loadTeam() async {
    team = await TeamDataManager.getTeam('d2pe9OlwAWmhmaBF77sV');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTeam();
  }

  @override
  Widget build(BuildContext context) {
    return team == null ? Container() : TeamPage(team: team);
  }
}
