import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/user_data.dart';

class ShowUserData extends StatefulWidget{
  UserData user;
  ShowUserData({this.user});
  @override
  State<StatefulWidget> createState() => _ShowUserDataState(user: user);
}

class _ShowUserDataState extends State<ShowUserData>{
  UserData user;
  _ShowUserDataState({this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  image: NetworkImage(user.imageurl) ?? AssetImage("assets/images/user"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.all(Radius.circular(75.0)),
              boxShadow: [
                BoxShadow(blurRadius: 7.0, color: Colors.white)
              ]),
        ),
        SizedBox(height: 20.0,),
        Text(user.fullname,
            style: TextStyle(
                color: Colors.blue,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal)),
        SizedBox(height: 15),
        Text('age : ' + (DateTime.now().difference(user.birthday).inDays/365).toStringAsFixed(1),
            style: TextStyle(
                color: Colors.blue,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal)),
        SizedBox(height: 15),
        Text('Gender : ' + user.gender,
            style: TextStyle(
                color: Colors.blue,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal)),

      ],
    );

  }

}