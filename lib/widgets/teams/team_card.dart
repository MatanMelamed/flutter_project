import 'package:flutter/material.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/widgets/general/diamond_image.dart';

class TeamCard extends StatefulWidget {
  final Team team;
  final Widget trailing;
  final void Function() callback;

  TeamCard({@required this.team, this.trailing, this.callback});

  @override
  _TeamCardState createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.callback ?? () {},
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10,right: 25),
//              color: Colors.red,
              child: DiamondImage(
                imageProvider: NetworkImage(widget.team.remoteStorageImage.url),
                size: 55,
                frameWidth: 4,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.team.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    ),
                  ),
                Text(
                  widget.team.description,
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
