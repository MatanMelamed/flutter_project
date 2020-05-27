import 'package:flutter/material.dart';
import 'package:teamapp/screens/chat/registration.dart';

import 'custom_button.dart';
import 'login.dart';

class MyHomePage extends StatelessWidget {
  static const String id = "HOMESCREEN";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  width: 100.0,
                  child: Image.asset("assets/images/default_profile_image.png"),
                ),
              ),
              Text(
                'Tensor Chat',
                style: TextStyle(fontSize: 40.0),
              ),
            ],
          ),
          SizedBox(
            height: 50.0,
          ),
          CustomButton(
            text: "Log in",
            callback: () => Navigator.of(context).pushNamed(Login.id),
          ),
          CustomButton(
            text: 'Register',
            callback: () => Navigator.of(context).pushNamed(Registration.id),
          )
        ],
      ),
    );
  }
}
