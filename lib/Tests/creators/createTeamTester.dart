import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/validator.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/theme/white.dart';
import 'package:teamapp/widgets/authenticate/inputs.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:teamapp/widgets/loading.dart';

class CreateTeamPageTester extends StatefulWidget {
  CreateTeamPageTester();

  @override
  _CreateTeamPageTesterState createState() => _CreateTeamPageTesterState();
}

class _CreateTeamPageTesterState extends State<CreateTeamPageTester> {
  var _teamName = TextEditingController();
  var _ownerID = TextEditingController();
  var _description = TextEditingController();
  bool isPrivate;
  var group = UsersList.fromWithinApp(membersUids: []);
  var meetings = [];

  double textInputHeight = 45;
  double distanceBetweenFields = 30;

  File _teamImage;

  bool loading = false;

  @override
  void dispose() {
    _teamName.dispose();
    _ownerID.dispose();
    _description.dispose();
    super.dispose();
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _teamImage = image;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _teamImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loading
          ? Loading()
          : Scaffold(
              backgroundColor: Colors.grey[900],
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: Text(
                              'Create Team',
                              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 40),
                            ),
                          ),
                        ),
                        SizedBox(height: distanceBetweenFields),
                        Container(
                          height: textInputHeight,
                          child: TextField(
                              controller: _teamName,
                              cursorColor: Colors.white70,
                              style: kLabelStyle,
                              decoration: GetInputDecor('Name')),
                        ),
                        SizedBox(height: distanceBetweenFields),
                        Container(
                          height: textInputHeight,
                          child: TextField(
                              controller: _ownerID,
                              cursorColor: Colors.white70,
                              style: kLabelStyle,
                              decoration: GetInputDecor('Owner ID')),
                        ),
                        SizedBox(height: distanceBetweenFields),
                        Container(
                          height: textInputHeight,
                          child: TextField(
                              controller: _description,
                              cursorColor: Colors.white70,
                              style: kLabelStyle,
                              decoration: GetInputDecor('Description')),
                        ),
                        SizedBox(height: distanceBetweenFields),
                        Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  image: _teamImage == null
                                      ? AssetImage("assets/images/default_profile_image.png")
                                      : FileImage(_teamImage),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.all(Radius.circular(75.0)),
                              boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)]),
                        ),
                        SizedBox(
                            height: 50.0,
                            child: Center(
                              child: Text(
                                'Choose Your Team Picture',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: 'add_from_camera',
                              onPressed: getImageFromCamera,
                              tooltip: 'Pick Image',
                              child: Icon(Icons.add_a_photo),
                            ),
                            FloatingActionButton(
                              heroTag: 'add_from_galery',
                              onPressed: getImageFromGallery,
                              tooltip: 'Pick Image',
                              child: Icon(Icons.image),
                            ),
                          ],
                        ),
                        SizedBox(height: distanceBetweenFields),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                            onPressed: () async {
                              setState(() => loading = true);

                              if (_teamName.text.isEmpty || _description.text.isEmpty){
                                print('some field is empty! must not be!');
                                setState(() => loading = false);
                                return;
                              }
                              String owner = _ownerID.text;
                              if (owner.isEmpty){
                                owner = Provider.of<User>(context).uid;
                              }
                              Team team = Team.fromWithinApp(
                                  name: _teamName.text,
                                  description: _description.text,
                                  isPublic: true,
                                  ownerUid: owner);

                              team = await TeamDataManager.createTeam(team, _teamImage,
                                  usersList: UsersList.fromWithinApp(membersUids: [_ownerID.text]));

                              setState(() => loading = false);

                              print(team.name + ' created.');
                              Navigator.of(context).pop();
                            },
                            color: Color(0x181919).withOpacity(0.97),
                            child: Text(
                              "Create !",
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  String validateError() {
    String error = Validator.ValidateImage(_teamImage);
    print(error);
    return error;
  }
}
