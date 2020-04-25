import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user_data.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';



class MainDrawer extends StatelessWidget {
  final AuthService _authService = AuthService();


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),//check!!
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top:30,bottom: 10),
                    decoration: BoxDecoration( //OPTIONAL
                      shape: BoxShape.circle,
//                        image: DecorationImage(image: NetworkImage(user.imageurl),
                      image: DecorationImage(image: NetworkImage('https://hgtvhome.sndimg.com/content/dam/images/hgtv/fullset/2018/3/22/0/shutterstock_national-puppy-day-224423782.jpg.rend.hgtvcom.966.725.suffix/1521744674350.jpeg'),
                        fit: BoxFit.fill
                      )
                    ),
                  ),
//                  Text(user.fullname,style: TextStyle(color: Colors.white,fontSize: 22),),
                  Text('Doggy@gmail.com',style: TextStyle(color: Colors.white),)
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile',style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('friends',style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Manage teams',style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Knowledge corner',style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.location_searching),
            title: Text('Fields',style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings',style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout',style: TextStyle(fontSize: 18)),
            onTap: () async {
              await _authService.signOut(); // wait until completion
            },
          ),
        ],
      ),
    );
  }
}
