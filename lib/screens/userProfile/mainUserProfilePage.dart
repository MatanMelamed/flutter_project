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
    return new Scaffold(
      appBar: null,
      body: new ListView(
        children: <Widget>[
          Container(
            child: Stack(
              alignment: Alignment.bottomCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Row(children: <Widget>[
                  Expanded(child:
                  Container(
                    height: 200.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('https://www.sageisland.com/wp-content/uploads/2017/06/beat-instagram-algorithm.jpg')
                        )
                    ),
                  ),)
                ],),
                Positioned(
                  top: 100.0,
                  child: Container(
                    height: 190.0,
                    width: 190.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        ),
                        border: Border.all(
                            color: Colors.white,
                            width: 6.0
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            alignment: Alignment.bottomCenter,
            height: 130.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(user.firstName + " " + user.lastName, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0
                )),
                SizedBox(width: 5.0,),
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.blueAccent,
                  tooltip: 'Increase volume by 10',
                  onPressed: () {
                    print('edit prass\n');
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 12.0,),

          Container(
            padding: EdgeInsets.only(left: 10.0,right: 10.0),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  ImageIcon(AssetImage('assets/icons/icons8-gender-100.png')),
                  SizedBox(width: 20.0,),
                  Text(user.gender,  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  )
                ],
                ),
                SizedBox(height: 10.0,),
                Row(children: <Widget>[
                  ImageIcon(AssetImage('assets/icons/icons8-age-100.png')),
                  SizedBox(width: 20.0,),
                  Text('age:  '+ (DateTime.now().difference(user.birthday).inDays/365).toStringAsFixed(1),  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  )
                ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}