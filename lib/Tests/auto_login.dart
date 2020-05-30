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

  final DummyUsers user;

  AutoLogin(this.user);

  login(){
    String email;
    if(user == DummyUsers.Motek){
      email = ""
    }
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

