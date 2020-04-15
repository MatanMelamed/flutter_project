import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class GroupCreationBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GroupCreationBodyState();
}

class _GroupCreationBodyState extends State<GroupCreationBody> {
  int curr = 0;
  List<Step> steps;
  List<String> friends = ['1', '2', '3'];
  final _friendsController = TextEditingController();
  static var data = GroupData();

  final _formKey = GlobalKey<FormState>();
  final _singleKeys = [
    GlobalKey<FormFieldState>(),
    GlobalKey<FormFieldState>(),
    GlobalKey<FormFieldState>()
  ];

  void _goTo(int step) {
    setState(() => curr = step);
  }

  void _cancel() {
    if (curr - 1 > 0) _goTo(curr - 1);
  }

  void _next() {
    if (_singleKeys[curr].currentState.validate()) {
      _singleKeys[curr].currentState.save();
      if (curr + 1 < steps.length) {
        _goTo(curr + 1);
      } else {
        // TODO: here is the last 'continue' so the app need to validate,
        // TODO: and than submit the data ...
      }
    }
  }

  Step _getFirstStep() {
    return StepCreator.getTextFormStep(
        title: 'Group\'s Name',
        labelText: 'Enter your Group\'s Name',
        key: _singleKeys[0],
        onSaved: (String value) {
          data.groupName = value;
          print("GroupName: " + data.groupName);
        },
        validator: (value) {
          if (value.isEmpty || value.length < 1) {
            print('Validator1 FAIL');
            return 'Please enter a Name';
          }
          print('Validator1 OK');
          return null;
        });
  }

  Step _getSecondStep() {
    return Step(
      title: Text('Friend\'s'),
      isActive: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TypeAheadFormField(
            key: _singleKeys[1],
            suggestionsCallback: (pattern) => ['AVI', 'ELI', 'YOSSI'],
            itemBuilder: (context, suggestion) =>
                ListTile(title: Text(suggestion)),
            transitionBuilder: (context, suggestionBox, controller) =>
                suggestionBox,
            onSuggestionSelected: (suggestion) {
              setState(() {
                friends.insert(0, suggestion);
                print("Friend added: " + suggestion);
                print(friends);
                _friendsController.clear();
              });
            },
            validator: (value) {
              if (value.isEmpty) {
                print('validator2 FAIL');
                return 'Please select friend';
              }
              print('validator2 OK');
              return null;
            },
            onSaved: (value) {
              data.members.addAll(friends);
              print("all Friends saved, 'value' == " + value);
            },
            textFieldConfiguration: TextFieldConfiguration(
              controller: _friendsController,
              decoration: InputDecoration(labelText: 'choose your friends'),
            ),
          ),
          SizedBox(
            height: 150.0,
            width: 300.0,
            child: ListView.builder(
              padding: EdgeInsets.all(1.0),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemExtent: 180.0,
              itemCount: friends.length,
              itemBuilder: (context, i) {
                print(i);
                return Container(
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(3.0),
                  child: Card(
                      child: ListTile(
                    leading: CircleAvatar(
                      radius: 15.0,
                      child: Icon(
                        Icons.remove,
                        size: 20.0,
                      ),
                    ),
                    title: Text(
                      'Regev Ben Ratzon',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  )),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Step _getThirdStep() {
    return StepCreator.getTextFormStep(
        title: 'Description',
        labelText: 'Enter Short Description',
        key: _singleKeys[2],
        maxLines: 4,
        onSaved: (String value) {
          data.description = value;
          print("description: " + data.description);
        });
  }

  @override
  Widget build(BuildContext context) {
    steps = <Step>[_getFirstStep(), _getSecondStep(), _getThirdStep()];

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Stepper(
            type: StepperType.vertical,
            currentStep: curr,
            onStepTapped: _goTo,
            onStepCancel: _cancel,
            onStepContinue: _next,
            steps: steps,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  // TODO: all input is OK, so need to submit and move to
                  // TODO: the previous page ...
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupData {
  String groupName;
  String description;
  bool public;
  List<String> members = List<String>();

  GroupData({this.groupName, this.public = false, this.description = ''});
}

class StepCreator {
  static Step getTextFormStep(
      {String title,
      String labelText,
      GlobalKey<FormFieldState> key,
      void Function(String) onSaved,
      String Function(String) validator,
      int maxLines = 1,
      double fontSize = 10}) {
    return Step(
      title: Text(title),
      isActive: true,
      content: TextFormField(
        key: key,
        keyboardType: TextInputType.text,
        onSaved: onSaved,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            decorationStyle: TextDecorationStyle.solid,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
