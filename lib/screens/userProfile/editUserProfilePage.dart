import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/validator.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';
import 'package:teamapp/theme/white.dart';
import 'package:teamapp/widgets/authenticate/inputs.dart';
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:gender_selection/gender_selection.dart';
import 'package:teamapp/widgets/loading.dart';

class EditUserPage extends StatefulWidget {
  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _date;

  double textInputHeight = 45;
  double distanceBetweenFields = 30;

  String _gender;
  DateTime _birthdayController;
  File _imageProfile;

  bool loading = false;

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
        initialDate: _birthdayController,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(DateTime.now().year - 3));
    if (picked != null &&
        (_birthdayController == null || picked != _birthdayController))
      setState(() {
        _birthdayController = picked;
        _date.value = TextEditingValue(text: dateFormat(picked));
      });
  }

  initialization(User currentOnlineUser) {
    _firstNameController =
        TextEditingController(text: currentOnlineUser.firstName);
    _lastNameController =
        TextEditingController(text: currentOnlineUser.lastName);
    _birthdayController = currentOnlineUser.birthday;
    _gender = currentOnlineUser.gender;
  }


  updateUserData(User currentOnlineUser) async{
    String error = validateError();

    if (error.isNotEmpty) {
      GetErrorDialog(
          context, 'Invalid Credentials', error);
    } else {
      setState(() => loading = true);

      User newUser = User.fromWithinApp(
          uid: currentOnlineUser.uid,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          gender: _gender,
          birthday: _birthdayController);

      // add to database

      await UserDataManager.updateUser(
          newUser, _imageProfile);

      setState(() {
        loading = false;
      });

     // SnackBar successSnackBar = SnackBar(content: Text("Profile has been update successfuly."),);
      //_scaffoldGlobalKey.currentState.showSnackBar(successSnackBar);



      // listen to user login - when user logs in - pop navigator
      Navigator.of(context).pop();
      // listen only once - only when waiting for creation process
      // end creation mode - will look for new user and notify in stream

    }
  }

  @override
  Widget build(BuildContext context) {
    final currentOnlineUser = Provider.of<User>(context);
    initialization(currentOnlineUser);
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
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40),
                            ),
                          ),
                        ),
                        SizedBox(height: distanceBetweenFields),
                        Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  image: _imageProfile == null
                                      ? NetworkImage(
                                          currentOnlineUser.remoteImage.url)
                                      : FileImage(_imageProfile),
                                  fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(75.0)),
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
                        SizedBox(height: distanceBetweenFields),
                        Container(
                          height: textInputHeight,
                          child: TextField(
                              controller: _firstNameController,
                              cursorColor: Colors.white70,
                              style: kLabelStyle,
                              decoration: GetInputDecor('First Name')),
                        ),
                        SizedBox(height: distanceBetweenFields),
                        Container(
                          height: textInputHeight,
                          child: TextField(
                              controller: _lastNameController,
                              cursorColor: Colors.white70,
                              style: kLabelStyle,
                              decoration: GetInputDecor('Last Name')),
                        ),
                        SizedBox(height: distanceBetweenFields),
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
                        SizedBox(height: distanceBetweenFields),
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
                            _gender =
                                gender.toString().substring("Gender.".length);
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
                        SizedBox(height: 60),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                            onPressed: () async {
                              updateUserData(currentOnlineUser);
                            },
                            color: Color(0x181919).withOpacity(0.97),
                            child: Text(
                              "Update !",
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
    String error = '';
    error += Validator.ValidateFullName(
            '${_firstNameController.text} ${_lastNameController.text}') +
        Validator.ValidateBirthday(_birthdayController) +
        Validator.ValidateGender(_gender);
    print(error);
    return error;
  }
}
