import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/Tests/creators/createTeamTester.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/teams/team_page.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/widgets/general/dialogs/alert_dialog.dart';
import 'package:teamapp/widgets/loading.dart';
import 'package:teamapp/widgets/teams/team_card.dart';

class UserTeams extends StatefulWidget {
  @override
  _UserTeamsState createState() => _UserTeamsState();
}

class _UserTeamsState extends State<UserTeams> {
  User currentUser;
  List<Team> teams;
  bool isLoading;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentUser = Provider.of<User>(context);
    _loadTeams();
  }

  _loadTeams() async {
    setState(() => isLoading = true);
    teams = await TeamDataManager.getUserTeams(currentUser);
    setState(() => isLoading = false);
  }

  showAlertDialog(BuildContext context, Team team) async {
    await showDialog(context: context,
        builder: (context) => GeneralAlertDialog(
          title: 'Alert',
          content: 'Are You Sure You Want To Delete ${team.name}',
          confirmCallback: () async {
            await TeamDataManager.deleteTeam(team.tid);
            setState(() => Navigator.of(context).pop());
          },
          cancelCallback: () => Navigator.of(context).pop(),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Manage your teams'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 170,
                      child: RaisedButton(
                        elevation: 10,
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>CreateTeamPageTester()));
                        },
                        child: Text(
                          "Create a new Team",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        color: Colors.blue,
                        ),
                      ),
                    SizedBox(width: 25),
                    Container(
                      width: 170,
                      child: RaisedButton(
                        elevation: 10,
                        onPressed: (){},
                        child: Text(
                          "Search a Team",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        color: Colors.blue,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? Loading()
                    : ListView.separated(
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: teams.length,
                        itemBuilder: (ctx, index) {
                          Team currentTeam = teams[index];
                          return Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                              child: TeamCard(
                                team: currentTeam,
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => TeamPage(team: currentTeam)));
                                },
                                onLongPress: () {
                                  showAlertDialog(context, currentTeam);
                                  setState(() {});
                                },
                              ),
                          );
                        },
                        separatorBuilder: (ctx, idx) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Divider(thickness: 2),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
