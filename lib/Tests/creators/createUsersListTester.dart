import 'package:flutter/material.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/services/firestore/usersListDataManager.dart';
import 'package:teamapp/theme/white.dart';
import 'package:teamapp/widgets/authenticate/inputs.dart';
import 'package:teamapp/widgets/loading.dart';

class Test_CreateUsersListPage extends StatefulWidget {
  @override
  _Test_CreateUsersListPageState createState() => _Test_CreateUsersListPageState();
}

class _Test_CreateUsersListPageState extends State<Test_CreateUsersListPage> {

  List<TextEditingController> _controllers = new List();

  bool loading = false;

  @override
  void dispose() {
    super.dispose();
    for (var i = 0; i < _controllers.length; i++) {
      _controllers[i].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return loading ? Loading() : SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text('Create Users List',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40
                                  ),
                            ),
                ),
              Container(
                width: width,
                height: height * 0.6,
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _controllers.length,
                  separatorBuilder: (ctx, idx) => Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                                controller: _controllers[index],
                                cursorColor: Colors.white70,
                                style: kLabelStyle,
                                decoration: GetInputDecor('User ID')
                                ),
                            ),
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.white,),
                            onPressed: () {
                              setState(() => _controllers.removeAt(index));
                            },
                            )
                        ],
                        ),
                      );
                  },

                  ),
                ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 25),
                width: width * 0.4,
                height: height * 0.15,
                child: RaisedButton(
                  elevation: 5,
                  child: Text(
                    'Create',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                        ),
                    ),
                  onPressed: () async {
//                    setState(() => loading = true);
                    List<String> membersUids = [];
                    for (int i = 0; i < _controllers.length; i++) {
                      membersUids.add(_controllers[i].text.toString());
                      print(_controllers[i].text);
                    }
                    UsersList usersList = UsersList.fromWithinApp(membersUids: membersUids);
                    usersList = await UsersListDataManager.createUsersList(usersList);
                    print('Created users list with ulid: ' +usersList.ulid);
                  },
                  ),
                )
            ],
            ),
          ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: addItem,
          ),
        ),
      );
  }

  addItem() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }
}
