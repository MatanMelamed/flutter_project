import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/widgets/meeting/AgeRangeSlider.dart';
import 'package:teamapp/models/location.dart';
import 'package:teamapp/models/meeting.dart';
import 'package:teamapp/models/sport.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/screens/location/search_address.dart';
import 'package:teamapp/screens/meetings/meeting_page.dart';
import 'package:teamapp/services/firestore/meetingDataManager.dart';
import 'package:teamapp/services/firestore/sportsDataManager.dart';
import 'package:teamapp/theme/white.dart';
import 'package:teamapp/widgets/authenticate/inputs.dart';
import 'package:teamapp/widgets/group_creation/usefull_widgets.dart';

class CreateMeeting extends StatefulWidget {
  final Team team;

  CreateMeeting({this.team});

  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  var meetingName = TextEditingController();
  var description = TextEditingController();
  var timeController = TextEditingController();
  var sports = TextEditingController();
  var _addressLocation = TextEditingController();
  DateTime time;
  MeetingStatus status;
  GeoPoint geoPointLocation;
  bool isPublic = false;
  bool isLoading = false;
  int _ageLimitEnd = 80;
  int _ageLimitStart = 15;
  Sport sport;

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

  Future<Meeting> publish() async {
    var meeting = Meeting.fromWithinApp(
      name: meetingName.text,
      description: description.text,
      status: MeetingStatus.APPROVED,
      time: time,
      isPublic: isPublic,
      ageLimitStart: _ageLimitStart,
      ageLimitEnd: _ageLimitEnd,
      location: geoPointLocation,
      sport: sport,
    );

    return await MeetingDataManager.createMeeting(widget.team, meeting);
  }

  String dateFormat(DateTime dateTime) {
    return formatDate(dateTime, [dd, '-', mm, '-', yyyy, ', ', hh, ':', nn]);
  }

  Future<DateTime> _pickTime(BuildContext context, DateTime dateTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      picked.hour,
      picked.minute,
    );
  }

  Future<DateTime> _pickDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year),
      firstDate: DateTime(1901, 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
  }

  Future<Null> _scheduleMeeting(BuildContext context) async {
    final DateTime picked = await _pickTime(
      context,
      await _pickDate(context),
    );

    if (picked != null && (time == null || picked != time))
      setState(
        () {
          time = picked;
          timeController.value = TextEditingValue(text: dateFormat(picked));
        },
      );
  }

  Future<void> _selectLocation(context) async {
    Location location = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchAddresses(),
      ),
    );
    setState(() {
      geoPointLocation = location.location;
      _addressLocation = TextEditingController(text: location.address);
    });
  }

  Future<List<Sport>> _getSportSuggestions(String pattern) async {
    return (await SportsDataManager.getAllSports())
        .where((e) => EnumToString.parse(e.sport)
            .toLowerCase()
            .startsWith(pattern.toLowerCase()))
        .toList();
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
                      'Create Meeting',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
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
                      padding: EdgeInsets.all(10.0),
                      child: TypeAheadFormField<Sport>(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: sports,
                          style: kLabelStyle,
                          decoration: GetInputDecor('Sport Type'),
                          cursorColor: Colors.white70,
                        ),
                        suggestionsCallback: _getSportSuggestions,
                        onSuggestionSelected: (s) {
                          print(s.sport);
                          sports.text = EnumToString.parse(s.sport);
                          sport = s;
                          setState(() {});
                        },
                        itemBuilder: (context, s) {
                          return SuggestionTile(
                            title: EnumToString.parse(s.sport),
                          );
                        },
                        validator: (str) {
                          if (sports.text.isEmpty) return "No Sport Was Chosen";
                          return null;
                        },
                        hideOnLoading: true,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () => _scheduleMeeting(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: timeController,
                            style: kLabelStyle,
                            keyboardType: TextInputType.datetime,
                            cursorColor: Colors.blue,
                            decoration: GetInputDecor('When ?'),
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
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Switch(
                            value: isPublic,
                            onChanged: (value) =>
                                setState(() => isPublic = value),
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
                    RaisedButton(
                      child: Text('Submit'),
                      onPressed: isLoading
                          ? null
                          : () async {
                              var uid = Provider.of<User>(
                                context,
                                listen: false,
                              ).uid;

                              if (!isValid()) {
                                print('is not valid');
                                return;
                              }

                              setState(() => isLoading = true);
                              var meeting = await publish();
                              setState(() => isLoading = false);

                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MeetingPage(
                                      ownerUID: uid, meeting: meeting),
                                ),
                              );
                              Navigator.of(context).pop();
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
}
