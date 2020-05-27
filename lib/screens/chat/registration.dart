import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/screens/chat/custom_button.dart';

import 'chat.dart';
import 'custom_text_field.dart';

class Registration extends StatefulWidget {
  static const String id = "REGISTRATION";

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String email;
  String password;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser() async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tensor Chat"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: 'logo',
              child: Container(
                child: Image.asset(
                  "assets/images/default_profile_image.png",
                ),
              ),
            ),
          ),
          SizedBox(height: 40.0),
          CustomTextField(
            hintText: "Please Enter Your E-mail",
            inputType: TextInputType.emailAddress,
            onChanged: (value) => this.email = value,
          ),
          SizedBox(height: 40.0),
          CustomTextField(
            discreet: true,
            hintText: "Please Enter Your Password",
            onChanged: (value) => this.password = value,
          ),
          CustomButton(
            text: "Register",
            callback: () async {
              await registerUser();
            },
          )
        ],
      ),
    );
  }
}
