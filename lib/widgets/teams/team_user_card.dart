import 'package:flutter/material.dart';
import 'package:teamapp/models/user.dart';

class UserCard extends StatefulWidget {
  final User user;
  final Widget trailing;
  final void Function() callback;
  final Widget subtitle;

  UserCard({@required this.user, this.trailing, this.callback, this.subtitle});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(widget.user.remoteImage.url),
          backgroundColor: Colors.red,
        ),
        subtitle: widget.subtitle,
        title: Text(
          widget.user.firstName + ' ' + widget.user.lastName,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
        ),
        trailing: widget.trailing ?? SizedBox(width: 0, height: 0),
        onTap: widget.callback ?? () {});
  }
}
