import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';

import 'package:teamapp/screens/chat/auth_wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return StreamProvider.value(
      value: authService.userStream, // what the provider listens to
      child: MaterialApp(
        home: AuthWrapper(),
      ),
    );
  }
}
