import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/Tests/LoadedPageTester.dart';
import 'package:teamapp/Tests/auto_login.dart';
import 'package:teamapp/Tests/creators/createTeamTester.dart';
import 'package:teamapp/Tests/creators/viewTeamPageTester.dart';
import 'package:teamapp/Tests/meeting/create_meeting_tester.dart';
import 'package:teamapp/Tests/meeting/view_meeting_tester.dart';
import 'package:teamapp/screens/meetings/team_meetings.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';
import 'package:teamapp/services/firestore/firestoreManager.dart';
import 'package:teamapp/services/firestore/sportsDataManager.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/widgets/auth_warrper.dart';

import 'models/sport.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  clear() async {
    await StorageManager.deleteCollection('team_to_users', subcollection: 'users');
    await StorageManager.deleteCollection('team_to_meetings');
    await StorageManager.deleteCollection('teams');
    await StorageManager.deleteCollection('user_teams', subcollection: 'teams');
    print('finished');
    // TeamDataManager.deleteTeam('dBb2q9FcUzZcwfQcrrSd');
  }

  void get() async {
    var list = await SportsDataManager.getAllSports();
    for (Sport item in list) {
      print(item.type);
      print(item.sport);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return StreamProvider.value(
      value: authService.userStream, // what the provider listens to
//      child: MaterialApp(
//        home: AuthWrapper(),
//      ),
            child: MaterialApp(
              home: AutoLogin(
                user: DummyUsers.Michael
              ),
            ),
    );
  }
}
