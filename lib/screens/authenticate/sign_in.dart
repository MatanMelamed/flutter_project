import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teamapp/screens/archive/page_transitions.dart';
import 'package:teamapp/screens/authenticate/sign_up.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';
import 'package:teamapp/theme/white.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

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

  Widget _buildSignInWithText() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Divider(
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'or sign in with',
            style: TextStyle(
                color: Colors.white, fontSize: 14, letterSpacing: 0.2),
          ),
        ),
        Expanded(
          child: Container(
            child: Divider(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialBtn(
      Function onTap, String logo_path, String name, int bgcolor) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Color(bgcolor).withOpacity(1),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      logo_path,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Center(child: Text(name, style: kLabelStyle))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildSocialBtn(() => print('Login with Facebook'),
            "assets/logos/facebook.svg", "Facebook", 0x4268B3),
        SizedBox(width: 15),
        _buildSocialBtn(() => print('Login with Google'),
            "assets/logos/google.svg", "Gmail", 0xE62F2E),
      ],
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        print('Sign up pressed');
        //widget.toggleView();
        //Navigator.push(context,PageSignUp());

        Navigator.of(context).push(createRoute(SignUp()));
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                letterSpacing: 0.2,
                fontFamily: 'OpenSans',
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  letterSpacing: 0.2,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600),
            ),
          ],
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
                Color(0x484848).withOpacity(0.47), BlendMode.darken),
            image: AssetImage("assets/images/background_1.png"),
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 44),
            child: Column(
              children: <Widget>[
                SizedBox(height: 66),
                _buildTitle(),
                _buildLogo(),
                SizedBox(height: 89),
                Form(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        child: TextFormField(
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          style: kLabelStyle,
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: kLabelStyle,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        height: 50,
                        child: TextFormField(
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          obscureText: true,
                          style: kLabelStyle,
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: kLabelStyle,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                // Button
                Container(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    onPressed: () {
                      print(email);
                      print(password);
                    },
                    color: Color(0x181919).withOpacity(0.97),
                    child: Text(
                      "Let's Go!",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                _buildSignInWithText(),
                SizedBox(height: 15.0),
                _buildSocialBtnRow(),
                SizedBox(height: 24.0),
                _buildSignupBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
