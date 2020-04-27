import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/user.dart';

class MainUserProfilePage extends StatefulWidget {
  final User user;
  final String defaultUserImage = 'assets/images/default_profile_image.png';

  MainUserProfilePage({this.user});

  @override
  State<StatefulWidget> createState() => _MainUserProfilePageState();
}

class _MainUserProfilePageState extends State<MainUserProfilePage> {
  User user;
  ImageProvider imageProvider;

  @override
  void initState() {
    user = widget.user;
    imageProvider = NetworkImage(user.remoteImage.url) ?? AssetImage(widget.defaultUserImage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.all(Radius.circular(75.0)),
              boxShadow: [
                BoxShadow(blurRadius: 7.0, color: Colors.white)
              ]),
          ),
        SizedBox(height: 20.0,),
        Text('${user.firstName} ${user.lastName}',
                 style: TextStyle(
                     color: Colors.white,
                     fontSize: 30.0,
                     fontWeight: FontWeight.bold,
                     fontStyle: FontStyle.normal)),
        SizedBox(height: 15),
        Text('age : ' + (DateTime
            .now()
            .difference(user.birthday)
            .inDays / 365).toStringAsFixed(1),
                 style: TextStyle(
                     color: Colors.white,
                     fontSize: 22.0,
                     fontWeight: FontWeight.bold,
                     fontStyle: FontStyle.normal)),
        SizedBox(height: 15),
        Text('Gender : ' + user.gender,
                 style: TextStyle(
                     color: Colors.white,
                     fontSize: 22.0,
                     fontWeight: FontWeight.bold,
                     fontStyle: FontStyle.normal)),

      ],
      );
  }

}