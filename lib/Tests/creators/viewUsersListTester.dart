import 'package:flutter/material.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/services/firestore/usersListDataManager.dart';
import 'package:teamapp/theme/white.dart';

class Test_ViewUsersListPage extends StatefulWidget {
  @override
  _Test_ViewUsersListPageState createState() => _Test_ViewUsersListPageState();
}

class _Test_ViewUsersListPageState extends State<Test_ViewUsersListPage> {
  UsersList usersList;

  loadUsersList() async {
    usersList = await UsersListDataManager.getUsersList('v7m9ZAgQLxc3ZJ3JRXdr');
    setState(() {});
  }

  @override
  void initState() {
    loadUsersList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: usersList == null
            ? //usersList == null
            Container()
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        'View Users List',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 40),
                      ),
                    ),
                    Container(
                      width: width,
                      height: height * 0.6,
                      child: ListView.separated(
                          itemBuilder: (ctx, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
                              child: Text(usersList.membersUids[index], style: kLabelStyle),
                            );
                          },
                          separatorBuilder: (ctx, idx) => Divider(),
                          itemCount: usersList.membersUids.length),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
