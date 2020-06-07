import 'package:flutter/material.dart';

class LoadedPageTester extends StatefulWidget {

  final dynamic Function() loadingFunction;
  final Widget Function(dynamic value) callback;

  LoadedPageTester({@required this.callback, @required this.loadingFunction});

  @override
  _LoadedPageTesterState createState() => _LoadedPageTesterState();
}

class _LoadedPageTesterState extends State<LoadedPageTester> {
  dynamic value;

  loadTeam() async {
    value = await widget.loadingFunction();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadTeam();
  }

  @override
  Widget build(BuildContext context) {
    return value == null ? Container() : widget.callback(value);
  }
}
