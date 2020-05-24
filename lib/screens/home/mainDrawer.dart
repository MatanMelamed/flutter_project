import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/friend/searchFriend.dart';
import 'package:teamapp/screens/friend/searchUsers.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';
import 'package:teamapp/screens/userProfile/mainUserProfilePage.dart';

class MainDrawer extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: true);
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20), //check!!
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 30, bottom: 10),
                    decoration: BoxDecoration(
                        //OPTIONAL
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(user.remoteImage.url),
                            fit: BoxFit.fill)),
                  ),
                  Text(
                    user.firstName + " " + user.lastName,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MainUserProfilePage(user: user)));
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('friends', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SearchFriends()));
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Manage teams', style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Knowledge corner', style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.location_searching),
            title: Text('Fields', style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings', style: TextStyle(fontSize: 18)),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout', style: TextStyle(fontSize: 18)),
            onTap: () async {
              await _authService.signOut(); // wait until completion
            },
          ),
        ],
      ),
    );
  }
}
