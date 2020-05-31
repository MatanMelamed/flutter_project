import 'package:flutter/material.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';
import 'package:teamapp/services/firestore/usersListDataManager.dart';
import 'package:teamapp/widgets/teams/team_user_card.dart';

class TeamAddUser extends StatefulWidget {
  final Team team;

  TeamAddUser({@required this.team});

  @override
  _TeamAddUserState createState() => _TeamAddUserState();
}

class _TeamAddUserState extends State<TeamAddUser> {
  UsersList teamUsersList;
  Stream<User> usersStream;
  List<User> allUsersList = [];
  List<User> filteredUsersList = [];

  List<String> markedUids = [];

  TextEditingController _filterController = TextEditingController();
  bool didClickOnFinishButton;

  @override
  void initState() {
    super.initState();
    didClickOnFinishButton = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUsers();
  }

  void _loadUsers() async {
    teamUsersList = await UsersListDataManager.getUsersList(widget.team.ulid);
    usersStream = UserDataManager.getAllUsers();
    usersStream.where((user) => !teamUsersList.membersUids.contains(user.uid)).listen((user) {
      setState(() => allUsersList.add(user));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _filterController.dispose();
  }

  Widget _getUsersListView(bool isFiltered) {
    return ListView.separated(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          User currentUser = isFiltered ? filteredUsersList[index] : allUsersList[index];
          return Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: UserCard(
                user: currentUser,
                trailing: markedUids.contains(currentUser.uid) ? Icon(Icons.done) : SizedBox(width: 0, height: 0),
                callback: () {
                  if (markedUids.contains(currentUser.uid)) {
                    markedUids.remove(currentUser.uid);
                  } else {
                    markedUids.add(currentUser.uid);
                  }
                  setState(() {});
                },
              ));
        },
        separatorBuilder: (ctx, idx) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(thickness: 2),
            ),
        itemCount: isFiltered ? filteredUsersList.length : allUsersList.length);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Card(
                  child: new ListTile(
                    leading: new Icon(Icons.search),
                    title: new TextField(
                      enabled: !didClickOnFinishButton,
                      controller: _filterController,
                      decoration: new InputDecoration(hintText: 'Search', border: InputBorder.none),
                      onChanged: onSearchTextChanged,
                    ),
                    trailing: new IconButton(
                      icon: new Icon(Icons.cancel),
                      onPressed: () {
                        _filterController.clear();
                        onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
              ),
              Expanded(child: _getUsersListView(filteredUsersList.length != 0 || _filterController.text.isNotEmpty)),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                width: 160,
                child: RaisedButton(
                  elevation: 10,
                  onPressed: didClickOnFinishButton ? null : onSubmitPressed,
                  child: Text(
                    "View Profile",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onSubmitPressed() async {
    // disable repeated clicks
    setState(() => didClickOnFinishButton = true);

    // adding users and waiting for addition to finish
    for (String id in markedUids) {
      await TeamDataManager.addUserToTeam(widget.team, newUserUid: id);
    }

    // return if any user was added.
    Navigator.of(context).pop(markedUids.isNotEmpty);
  }

  void onSearchTextChanged(String input) async {
    filteredUsersList.clear();
    if (input.isEmpty) {
      setState(() {});
      return;
    }
    String fullName;
    allUsersList.forEach((user) {
      fullName = user.firstName.toLowerCase() + ' ' + user.lastName.toLowerCase();
      if (fullName.contains(input.toLowerCase())) {
        filteredUsersList.add(user);
      }
    });

    setState(() {});
  }
}
