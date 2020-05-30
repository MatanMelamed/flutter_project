import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/Tests/auto_login.dart';
import 'package:teamapp/Tests/creators/viewTeamPageTester.dart';
import 'package:teamapp/screens/teams/team_page.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return StreamProvider.value(
      value: authService.userStream, // what the provider listens to
      child: MaterialApp(
        home: AutoLogin(user: DummyUsers.Michael,child: ViewTeamPageTester()),
      ),
    );
  }
}
