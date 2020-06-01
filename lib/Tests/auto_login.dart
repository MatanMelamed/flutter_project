import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/home/home.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';
import 'package:teamapp/widgets/loading.dart';

enum DummyUsers { Mike, Motek, Elizabeth, Michael }

class AutoLogin extends StatelessWidget {
  final DummyUsers user;
  final Widget child;
  final Map<DummyUsers, String> userToUid = new Map();

  AutoLogin({@required this.user, this.child}) {
    userToUid[DummyUsers.Mike] = '6XmkIWBQOQTSH1DKNkqpNl697mF3';
    userToUid[DummyUsers.Motek] = '3vgCItKZeXNQemeewn59rfrZFfV2';
    userToUid[DummyUsers.Elizabeth] = 'C5h3rKCR9Rh7qbGmfc3didEuZlu1';
    userToUid[DummyUsers.Michael] = 'lLV6SK8LhiTLXLCgfYbx6iDLOYs1';
  }

  login() async {
    AuthService authService = AuthService();
    String email = (await UserDataManager.getUser(userToUid[user])).email;
    authService.signInWithEmailAndPassword(email, '123123123');
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      login();
    }

    return user == null ? Loading() : child ?? Home();
  }
}
