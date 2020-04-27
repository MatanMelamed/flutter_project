import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/authenticate/authenticate.dart';
import 'file:///C:/Users/Eden/AndroidStudioProjects/flutter_project/lib/screens/home/home.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // return either home or authenticate widget
    return user != null ? Home() : Authenticate();
  }
}
