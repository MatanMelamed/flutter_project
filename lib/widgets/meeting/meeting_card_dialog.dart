import 'package:flutter/material.dart';

class MeetingCardDialog extends StatefulWidget {
  final bool isInMeeting;
  final bool isApproved;

  MeetingCardDialog({
    @required this.isInMeeting,
    @required this.isApproved,
  });

  @override
  _MeetingCardDialogState createState() => _MeetingCardDialogState();
}

class _MeetingCardDialogState extends State<MeetingCardDialog> {

  String firstOption = '';
  String secondOption = '';


  @override
  void initState() {
    super.initState();
       firstOption = (widget.isInMeeting ? '' : 'Join Meeting & ') +
      (widget.isApproved ? 'Cancel Arrival':'Approve Arrival');
      secondOption = widget.isInMeeting ? 'Leave Meeting' : 'Join Meeting';
  }

  Widget createSingleButton(String option, int index) {
    return Container(
      width: 100,
//      height: 100,
      padding: EdgeInsets.only(left: 5),
      child: RaisedButton(
        elevation: 10,
        onPressed: () => buttonPressed(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            option,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        color: Colors.blue[900],
      ),
    );
  }

  void buttonPressed(index) {
    Navigator.of(context).pop(index);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 15,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        color: Colors.black12,
        child: Row(
          children: [
            Container(
              width: 100,
              padding: EdgeInsets.only(left: 5),
              child: RaisedButton(
                elevation: 10,
                onPressed: () => buttonPressed(0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    firstOption,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                color: Colors.blue[900],
              ),
            ),
            Container(
              width: 100,
              padding: EdgeInsets.only(left: 5),
              child: RaisedButton(
                elevation: 10,
                onPressed: () => buttonPressed(1),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue[900], fontSize: 16),
                  ),
                ),
                color: Colors.white,
                shape: Border.all(color: Colors.blue[900]),

                ),
            ),
            Container(
              width: 100,
              padding: EdgeInsets.only(left: 5),
              child: RaisedButton(
                elevation: 10,
                onPressed: () => buttonPressed(2),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    secondOption,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                color: Colors.blue[900],
              ),
            )
          ],
        ),
      ),
    );
  }


}
