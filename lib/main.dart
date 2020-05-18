import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/screens/Tests/AddImages.dart';
import 'package:teamapp/screens/teams/team_page.dart';
import 'package:teamapp/screens/Tests/teamsDataManagerTester.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';
import 'package:teamapp/widgets/general/dummy.dart';
import 'package:teamapp/widgets/general/editViewImage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return StreamProvider.value(
      value: authService.userStream, // what the provider listens to
      child: MaterialApp(
        //home: AuthWrapper(),
        //home: DummyNavigateOnClick(w: TeamPage(team: ,)),
        //home: DummyNavigateOnClick(w: FullScreenImage()),
        home: Tries(),
      ),
    );
  }
}
