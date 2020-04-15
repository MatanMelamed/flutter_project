import 'package:flutter/material.dart';
import 'package:teamapp/models/slide_right_transition.dart';
import 'package:teamapp/models/user_data.dart';
import 'package:teamapp/screens/profile/create_profile.dart';
import 'package:teamapp/screens/profile/show_user.dart';
import 'package:teamapp/widgets/clip_path.dart';
import 'package:teamapp/services/database/user_management.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  ProfilePage({ this.uid });

  @override
  _ProfilePageState createState() => _ProfilePageState(uid: this.uid);
}

class _ProfilePageState extends State<ProfilePage> {
  final String uid;
  _ProfilePageState({ this.uid });

  Widget _buildEditProfileBtn(){

    return RaisedButton.icon(
      icon: Icon(Icons.edit),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6)),
      onPressed: () async {
        print('Edit Profile pressed');
        Navigator.push(context, SlideRightRoute(widget: CreateProfile()));
      },
      color: Colors.greenAccent.withOpacity(0.97),
      label: Text(
        "Edit Profile",
        style: TextStyle(
            color: Colors.white,
            letterSpacing: 0.3,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
            fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return StreamProvider<UserData>.value(
      value: UserManagement(uid: this.uid).user,
      child: Scaffold(
          body: Container(
        color: Colors.black,
        child: new Stack(
          children: <Widget>[
            ClipPath(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Color(0x484848).withOpacity(0.47), BlendMode.darken),
                    image: AssetImage("assets/images/background_4.png"),
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              clipper: getClipper(),
            ),
            Positioned(
              width: 350.0,
              left: 25.0,
              top: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 300.0, child: ShowUserData(),),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                      height: 35.0, width: 200.0, child: _buildEditProfileBtn()),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
