import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/location.dart';
import 'package:teamapp/screens/location/search_address.dart';
import 'package:teamapp/screens/meetings/choose_sport.dart';
import 'package:teamapp/theme/white.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:teamapp/widgets/general/future_list.dart';

class SearchForAOneTimeMeeting extends StatefulWidget {
  @override
  _SearchForAOneTimeMeetingState createState() =>
      _SearchForAOneTimeMeetingState();
}

class _SearchForAOneTimeMeetingState extends State<SearchForAOneTimeMeeting> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text('Search Meeting'),
        ),
        body: SearchMeeting());
  }
}

class SearchMeeting extends StatefulWidget {
  _SearchMeetingState createState() => _SearchMeetingState();
}

class _SearchMeetingState extends State<SearchMeeting> {
  GeoPoint geoPointLocation;
  var _addressLocation = TextEditingController();
  var _sportTypes = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  var _dateRange = TextEditingController();
  var selectedSportType;
  var _currentSliderValue = 10.0;

  Future displayDateRangePicker(BuildContext context) async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: _startDate,
        initialLastDate: _endDate,
        firstDate: new DateTime(DateTime.now().year - 50),
        lastDate: new DateTime(DateTime.now().year + 50));
    if (picked != null && picked.length == 2) {
      setState(() {
        _startDate = picked[0];
        _endDate = picked[1];
        _dateRange = TextEditingController(
            text: dateFormat(_startDate) + " - " + dateFormat(_endDate));
      });
    }
  }

  String dateFormat(DateTime dateTime) {
    return formatDate(dateTime, [dd, '/', mm, '/', yyyy]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 100,
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () => _selectLocation(context),
            child: AbsorbPointer(
              child: TextFormField(
                controller: _addressLocation,
                style: kLabelStyleBlue,
                cursorColor: Colors.blueAccent,
                decoration: GetInputDecorBlue('you location..'),
              ),
            ),
          ),
        ),
        Text(
          'choose max distance in KM',
          style: kLabelStyleBlue,
        ),
        Slider(
          value: _currentSliderValue,
          min: 0,
          max: 50,
          divisions: 50,
          label: _currentSliderValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              displayDateRangePicker(context);
            }, //Navigator.of(context).push(SfDateRangePicker()),
            child: AbsorbPointer(
              child: TextFormField(
                controller: _dateRange,
                style: kLabelStyleBlue,
                cursorColor: Colors.blueAccent,
                decoration: GetInputDecorBlue('date range..'),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () => _selectSportType(context),
            child: AbsorbPointer(
              child: TextFormField(
                controller: _sportTypes,
                style: kLabelStyleBlue,
                cursorColor: Colors.blueAccent,
                decoration: GetInputDecorBlue('sport types..'),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 35,
        ),
        Container(
          width: double.infinity,
          height: 50,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            onPressed: () async{
              await handleSearchButton(context);
            },
            color: Colors.blueAccent,
            child: Text(
              "Search !",
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.3,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
          ),
        )
      ],
    );
  }

  InputDecoration GetInputDecorBlue(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: kLabelStyleBlue,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(7),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }

  Future<void> _selectLocation(context) async {
    Location location = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SearchAddresses(),
    ));
    setState(() {
      geoPointLocation = location.location;
      _addressLocation = TextEditingController(text: location.address);
    });
  }

  Future<void> _selectSportType(context) async {
    String sportTypes = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChooseSportType(),
    ));
    setState(() {
      _sportTypes = TextEditingController(text: sportTypes);
    });
  }

  Future<void> handleSearchButton(context) async{
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FutureList(
              _currentSliderValue.toInt(),
              geoPointLocation,
              _startDate,
              _endDate,
              _sportTypes.value.text,
              "all your result"
      ),
    ));
  }
}
