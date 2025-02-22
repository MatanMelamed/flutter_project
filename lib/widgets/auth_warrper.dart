import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/authenticate/authenticate.dart';
import 'package:teamapp/screens/home/homePage.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // return either home or authenticate widget
    return user != null ? HomePage() : Authenticate();
  }
}
