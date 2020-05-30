import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifactions"),
        centerTitle: true,
      ),
      body: Container(
        child: Text("notifications Page", style: TextStyle(fontSize: 40,color: Colors.white)),
        alignment: Alignment.center,
      ),
    );
  }
}