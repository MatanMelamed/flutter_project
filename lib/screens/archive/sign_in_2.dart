import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:teamapp/theme/white.dart';

class SignIn2 extends StatefulWidget {
  @override
  _SignIn2State createState() => _SignIn2State();
}

class _SignIn2State extends State<SignIn2> {
  Widget _getLogo() {
    return Container(
      width: 140.0,
      height: 140.0,
      decoration: BoxDecoration(
        //border: Border.all(color: Colors.pink),
        image: DecorationImage(
          image: AssetImage("assets/logos/teamapp.png"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- Or Sign in with -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTextInput(String s) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 5, top: 15),
        hintText: s,
        hintStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.darken),
            image: AssetImage("assets/images/background_1.png"),
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "TeamApp",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                      fontFamily: "OpenSans",
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 30.0, bottom: 25),
                  child: _getLogo(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        _getTextInput("Email"),
                        SizedBox(height: 30.0),
                        _getTextInput("Password"),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 55.0),
                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                  onPressed: () {},
                  color: Colors.white.withOpacity(0.35),
                  child: Text(
                    "Let's Go!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                _buildSignInWithText(),
                SizedBox(height: 15.0),
                _buildSocialBtnRow(),
                SizedBox(height: 15.0),
                _buildSignupBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
