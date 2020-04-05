import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';
import 'package:teamapp/theme/white.dart';

class SignUp extends StatefulWidget {

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Color(0x484848).withOpacity(0.47), BlendMode.darken),
            image: AssetImage("assets/images/background_2.png"),
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:14,top:14),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: (){
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
                            SizedBox(height: 26.0),
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
                      SizedBox(height: 72.0),
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
            )
          ),
        ),
      ),
    );
  }
}
