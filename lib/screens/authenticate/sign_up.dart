import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:teamapp/models/validator.dart';
import 'package:teamapp/screens/archive/page_transitions.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';
import 'package:teamapp/theme/white.dart';
import 'package:teamapp/widgets/authenticate/inputs.dart';
import 'package:teamapp/widgets/loading.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _passwordValidationTextController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _passwordValidationTextController.dispose();
    super.dispose();
  }

  Widget _buildTitle() {
    return Container(
      //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Center(
        child: Text(
          "TeamApp",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: "Heebo",
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 110.0,
      height: 110.0,
      child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Image.asset("assets/logos/teamapp.png")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Color(0x484848).withOpacity(0.47), BlendMode.darken),
            image: AssetImage("assets/images/background_2.png"),
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
          ),
        ),
        child: loading ? Loading() : Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 14, top: 14),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        //widget.toggleView();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 44),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 66),
                        _buildTitle(),
                        _buildLogo(),
                        SizedBox(height: 89),
                        Column(
                          children: <Widget>[
                            Container(
                              height: 50,
                              child: TextField(
                                  controller: _emailTextController,
                                  style: kLabelStyle,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: GetInputDecor('Email')),
                            ),
                            SizedBox(height: 16.0),
                            Container(
                              height: 50,
                              child: TextField(
                                  controller: _passwordTextController,
                                  obscureText: true,
                                  style: kLabelStyle,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: GetInputDecor('Password')),
                            ),
                            SizedBox(height: 16.0),
                            Container(
                              height: 50,
                              child: TextField(
                                  controller: _passwordValidationTextController,
                                  obscureText: true,
                                  style: kLabelStyle,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: GetInputDecor('Password validation')),
                            ),
                          ],
                        ),
                        SizedBox(height: 72.0),
                        // Button
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                            onPressed: () async {
                              String email = _emailTextController.text;
                              String password = _passwordTextController.text;
                              String passValid = _passwordValidationTextController.text;

                              print('email: $email, password: $password');

                              String error = '';
                              error += Validator.ValidateEmail(email);
                              error += error.isNotEmpty ? '\n' : '';
                              error += Validator.ValidatePassword(password);
                              error += error.isNotEmpty ? '\n' : '';
                              error += password == passValid ? '' : 'passwords do not match';

                              if (error.isNotEmpty) {
                                GetErrorDialog(context, 'Invalid Credentials', error);
                              } else {
                                setState(() => loading = true);
                                var result = await _auth.registerWithEmailAndPassword(email, password);

                                if (result == null) {
                                  setState(() => loading = false);
                                  GetErrorDialog(
                                      context, 'Registration Error', 'One or more of the details is not valid.');
                                  print('failed to register');
                                } else {
                                  print('registered');
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                            color: Color(0x181919).withOpacity(0.97),
                            child: Text(
                              "Sign Up",
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
                ],
              )),
        ),
      ),
    );
  }
}
