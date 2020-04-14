import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user_data.dart';

class ShowUserData extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ShowUserDataState();

}

class _ShowUserDataState extends State<ShowUserData>{
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserData>(context);

    return Column(
      children: <Widget>[
        Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
              color: Colors.white,
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
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal)),
        SizedBox(height: 15),
        Text('age : ' + (DateTime.now().difference(user.birthday).inDays/365).toStringAsFixed(1),
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