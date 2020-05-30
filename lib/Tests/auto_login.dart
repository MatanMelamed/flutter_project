import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';

enum DummyUsers{
  Mike,
  Motek,
  Elizabeth,
  Michael
}

class AutoLogin extends StatelessWidget {

  DummyUsers user;
  Map<DummyUsers,String> userToUid;

  AutoLogin(this.user){
    userToUid = new Map();
    userToUid[DummyUsers.Mike] = '6XmkIWBQOQTSH1DKNkqpNl697mF3';
    userToUid[DummyUsers.Motek] = '3vgCItKZeXNQemeewn59rfrZFfV2';
    userToUid[DummyUsers.Elizabeth] = 'C5h3rKCR9Rh7qbGmfc3didEuZlu1';
    userToUid[DummyUsers.Michael] = 'lLV6SK8LhiTLXLCgfYbx6iDLOYs1';
  }

  login() async {
    AuthService authService = AuthService();
    String email = (await UserDataManager.getUser(userToUid[user])).e;
    authService.signInWithEmailAndPassword(email, password)
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user == null){
      login();
    }

    return Container(


    );
  }


}

