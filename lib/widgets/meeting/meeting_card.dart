import 'package:flutter/material.dart';
import 'package:teamapp/models/meeting.dart';

class MeetingCard extends StatefulWidget {
  final Meeting meeting;
  final Widget trailing;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  MeetingCard({@required this.meeting, this.trailing, this.onTap, this.onLongPress});

  @override
  _MeetingCardState createState() => _MeetingCardState();
}

class _MeetingCardState extends State<MeetingCard> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress ?? () {},
      onTap: widget.onTap ?? () {},
      child: Container(
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.meeting.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    ),
                  ),
                Text(
                  widget.meeting.description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                    ),
                  )
              ],
              )
          ],
          ),
        ),
      );
  }
}
