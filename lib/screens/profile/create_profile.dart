import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/validator.dart';
import 'package:teamapp/services/database/user_management.dart';
import 'package:teamapp/theme/white.dart';
import 'package:teamapp/widgets/authenticate/inputs.dart';
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:gender_selection/gender_selection.dart';

class CreateProfile extends StatefulWidget {
  final String uid;
  CreateProfile({ this.uid });

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {

  final _fullNameTextController = TextEditingController();
  DateTime _birthdayController;
  TextEditingController _date = new TextEditingController();
  File _imageProfile;
  String _gender;



  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageProfile = image;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageProfile = image;
    });
  }

  String dateFormat(DateTime dateTime) {
    return formatDate(dateTime, [dd, '-', mm, '-', yyyy]);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year - 3),
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(DateTime.now().year - 3));
    if (picked != null &&
        (_birthdayController == null || picked != _birthdayController))
      setState(() {
        _birthdayController = picked;
        _date.value = TextEditingValue(text: dateFormat(picked));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        body: ListView(children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height / 7,
              child: Center(
                child: Text(
                  'Edit Your Profile:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
              )),
          Positioned(
              width: 350.0,
              left: 25.0,
              top: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: _imageProfile == null
                                ? AssetImage("assets/images/user.png")
                                : FileImage(_imageProfile),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ]),
                  ),
                  SizedBox(
                      height: 50.0,
                      child: Center(
                        child: Text(
                          'Choose Your Profile Picture',
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
                  SizedBox(
                    height: 35.0,
                  ),
                  Container(
                    height: 50,
                    child: TextField(
                        controller: _fullNameTextController,
                        style: kLabelStyle,
                        cursorColor: Colors.blue,
                        keyboardType: TextInputType.text,
                        decoration: GetInputDecor('Full Name')),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 50,
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _date,
                          style: kLabelStyle,
                          keyboardType: TextInputType.datetime,
                          cursorColor: Colors.blue,
                          decoration: GetInputDecor('Date of Birth'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  GenderSelection(
                    unSelectedGenderTextStyle: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.3),
                    maleText: "Male",
                    //default Male
                    femaleText: "Female",
                    //default Female
                    selectedGenderTextStyle: kLabelStyle,
                    selectedGenderIconBackgroundColor: Colors.indigo,
                    checkIconAlignment: Alignment.bottomCenter,
                    // default bottomRight
                    selectedGenderCheckIcon: Icons.check,
                    // default Icons.check
                    onChanged: (Gender gender) {
                      _gender = gender.toString();
                      print(gender);
                    },
                    equallyAligned: true,
                    animationDuration: Duration(milliseconds: 400),
                    isCircular: true,
                    isSelectedGenderIconCircular: true,
                    opacityOfGradient: 0.6,
                    padding: const EdgeInsets.all(3),
                    size: 120, //default : 120
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                      onPressed: () async {
                        String error = valideError();

                        if (error.isNotEmpty) {
                          GetErrorDialog(context, 'Invalid Credentials', error);
                        }
                        else{
                          var result = await UserManagement(uid: widget.uid)
                              .singUpUserData(_fullNameTextController.text, _birthdayController, _gender, _imageProfile);
                          print(result);

                          Navigator.of(context).pop();
                        }

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
              )),
        ]));
  }

  String valideError() {
    String error = '';
    error += Validator.ValidateFullName(
        _fullNameTextController.text) +
        Validator.ValidateBirthday(_birthdayController) +
        Validator.ValidateGender(_gender) +
        Validator.ValidateImage(_imageProfile);
    print(error);
    return error;
  }
}
