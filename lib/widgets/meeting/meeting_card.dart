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
        height: 80,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 7, left: 10),
                  child: Text(
                    widget.meeting.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 20),
                  child: Text(
                    "sport",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 20),
                  child: Text(
                    widget.meeting.time.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                      ),
                    ),
                  )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15, right: 5),
                  child: Text(
                    '10/20',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, right: 5),
                  child: Text(
                    '500 m',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
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
