import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/widgets/meeting/AgeRangeSlider.dart';
import 'package:teamapp/models/location.dart';
import 'package:teamapp/models/meeting.dart';
import 'package:teamapp/models/sport.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/screens/location/search_address.dart';
import 'package:teamapp/services/firestore/meetingDataManager.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/theme/white.dart';
import 'package:teamapp/widgets/authenticate/inputs.dart';
import 'package:teamapp/services/general/utilites.dart';

class CreateMeetingTester extends StatefulWidget {

  final Team team;

  CreateMeetingTester({this.team});

  @override
  _CreateMeetingTesterState createState() => _CreateMeetingTesterState();
}

class _CreateMeetingTesterState extends State<CreateMeetingTester> {
  var meetingName = TextEditingController();
  var description = TextEditingController();
  var timeController = TextEditingController();
  DateTime time;
  bool isPublic = false;
  int _ageLimitStart = 15;
  int _ageLimitEnd = 80;
  var sports = TextEditingController();
  GeoPoint geoPointLocation;
  var _addressLocation = TextEditingController();

  MeetingStatus status;

  bool isLoading = false;

  bool isValid() {
    return meetingName.text.isNotEmpty && description.text.isNotEmpty;
  }

  @override
  void dispose() {
    super.dispose();
    meetingName.dispose();
    description.dispose();
    sports.dispose();
    timeController.dispose();
  }

  void publish() async {
    var meeting = Meeting.fromWithinApp(
      name: meetingName.text,
      description: description.text,
      status: MeetingStatus.APPROVED,
      time: time,
      isPublic: isPublic,
      ageLimitStart: _ageLimitStart,
      ageLimitEnd: _ageLimitEnd,
      location: geoPointLocation,
      sport: Sport(type: SportType.Aerobic, sport: SubSport.CrossFit)
    );
    MeetingDataManager.createMeeting(widget.team, meeting);
  }

  String dateFormat(DateTime dateTime) {
    return formatDate(dateTime, [dd, '-', mm, '-', yyyy]);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year),
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(DateTime.now().year + 1));
    if (picked != null && (time == null || picked != time))
      setState(() {
        time = picked;
        timeController.value = TextEditingValue(text: dateFormat(picked));
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(top: 50, bottom: 20),
                  child: Center(
                    child: Text(
                      'Create a meeting tester',
                      style: TextStyle(fontSize: 30, color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                          controller: meetingName,
                          cursorColor: Colors.white70,
                          style: kLabelStyle,
                          decoration: GetInputDecor('Meeting Name')),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                          controller: description,
                          cursorColor: Colors.white70,
                          style: kLabelStyle,
                          decoration: GetInputDecor('Meeting description')),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: timeController,
                            style: kLabelStyle,
                            keyboardType: TextInputType.datetime,
                            cursorColor: Colors.blue,
                            decoration: GetInputDecor('Date to Meet'),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 15),
                            child: Text(
                              'Is public?',
                              style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Switch(
                            value: isPublic,
                            onChanged: (value) => setState(() => isPublic = value),
                          ),
                        ],
                      ),
                    ),
                    AgeRangeSliders(
                      currentStart: 15,
                      currentEnd: 80,
                      callback: (a, b) {
                        _ageLimitStart = a;
                        _ageLimitEnd = b;
                      },
                    ),
                    // TODO
                    Container(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () => _selectLocation(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _addressLocation,
                            style: kLabelStyle,
                            cursorColor: Colors.blue,
                            decoration: GetInputDecor('Meeting location'),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                          controller: sports,
                          cursorColor: Colors.white70,
                          style: kLabelStyle,
                          decoration: GetInputDecor('Meeting sport')),
                      ),
                    RaisedButton(

                      child: Text('Submit'),
                      onPressed: isLoading ? null : () async {
                        if (!isValid()){
                          print('is not valid');
                          return;
                        }
                        setState(()=>isLoading = true);
                        await publish();
                        setState(()=>isLoading = false);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectLocation(context) async {
    Location location = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SearchAddresses(),
        ));
    setState(() {
      geoPointLocation = location.location;
      _addressLocation = TextEditingController(text: location.address);
    });
  }
}
