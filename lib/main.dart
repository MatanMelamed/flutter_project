import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/services/authenticate/auth_service.dart';
import 'package:teamapp/widgets/auth_warrper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().user_stream, // what the provider listens to
      child: MaterialApp(
        home: AuthWrapper(),
      ),
    );
  }
}
