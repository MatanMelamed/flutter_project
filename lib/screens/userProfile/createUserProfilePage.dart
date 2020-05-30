import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/validator.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';
import 'package:teamapp/theme/white.dart';
import 'package:teamapp/widgets/authenticate/inputs.dart';
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:gender_selection/gender_selection.dart';
import 'package:teamapp/widgets/loading.dart';

class CreateUserPage extends StatefulWidget {
  CreateUserPage();

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final AuthService _auth = AuthService();

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _passwordValidationController = TextEditingController();
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _date = TextEditingController();

  double textInputHeight = 45;
  double distanceBetweenFields = 30;

  String _gender;
  DateTime _birthdayController;
  File _imageProfile;

  bool loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordValidationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _date.dispose();
    super.dispose();
  }

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
                              'Create User',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40),
                            ),
                          ),
                        ),
                        SizedBox(height: distanceBetweenFields),
                        Container(
                          height: textInputHeight,
                          child: TextField(
                              controller: _emailController,
                              cursorColor: Colors.white70,
                              style: kLabelStyle,
                              decoration: GetInputDecor('Email')),
                        ),
                        SizedBox(height: distanceBetweenFields),
                        Container(
                          height: textInputHeight,
                          child: TextField(
                              controller: _passwordController,
                              cursorColor: Colors.white70,
                              style: kLabelStyle,
                              decoration: GetInputDecor('Password')),
                        ),
                        SizedBox(height: distanceBetweenFields),
                        Container(
                          height: textInputHeight,
                          child: TextField(
                              controller: _passwordValidationController,
                              cursorColor: Colors.white70,
                              style: kLabelStyle,
                              decoration: GetInputDecor('Password validation')),
                        ),
                        SizedBox(height: distanceBetweenFields),
                        Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  image: _imageProfile == null
                                      ? AssetImage(
                                          "assets/images/default_profile_image.png")
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
                              String email = _emailController.text;
                              String password = _passwordController.text;

                              String error = validateError();

                              if (error.isNotEmpty) {
                                GetErrorDialog(
                                    context, 'Invalid Credentials', error);
                              } else {
                                setState(() => loading = true);

                                // turn authentication to creation mode
                                _auth.startCreationMode();

                                // creating new user must be while auth service in creation mode
                                var authSignUpResult =
                                    await _auth.registerWithEmailAndPassword(
                                        email, password);

                                // if failed to register
                                if (authSignUpResult == null) {
                                  setState(() => loading = false);
                                  GetErrorDialog(context, 'Registration Error',
                                      'One or more of the details is not valid.');
                                  print('failed to register');
                                } else {
                                  print('registered successfully');

                                  User newUser = User.fromWithinApp(
                                      email: authSignUpResult.email,
                                      uid: authSignUpResult.uid,
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      gender: _gender,
                                      birthday: _birthdayController);

                                  // add to database
                                  await UserDataManager.createUser(
                                      newUser, _imageProfile);

                                  // listen to user login - when user logs in - pop navigator
                                  var listener;
                                  listener = _auth.userStream.listen((data) {
                                    Navigator.of(context).pop();
                                    // listen only once - only when waiting for creation process
                                    listener.cancel();
                                  });

                                  // end creation mode - will look for new user and notify in stream
                                  _auth.endCreationMode();
                                }
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
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  String validateError() {
    String error = '';
    error += Validator.ValidateEmail(_emailController.text) +
        Validator.ValidatePasswords(
            _passwordController.text, _passwordValidationController.text) +
        Validator.ValidateFullName(
            '${_firstNameController.text} ${_lastNameController.text}') +
        Validator.ValidateBirthday(_birthdayController) +
        Validator.ValidateGender(_gender) +
        Validator.ValidateImage(_imageProfile);
    print(error);
    return error;
  }
}
