import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:teamapp/models/group_sketch.dart';
import 'package:teamapp/widgets/group_creation/usefull_widgets.dart';

class GroupCreationBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GroupCreationBodyState();
}

class _GroupCreationBodyState extends State<GroupCreationBody> {
  int curr = 0;
  List<Step> steps;
  List<String> friends = [];
  bool isPublic = true;
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
    if (curr - 1 >= 0) _goTo(curr - 1);
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

  Step _getGroupNameStep() {
    return Step(
        title: Text('Group\'s Name'),
        isActive: true,
        content: FormCreator.getTextFormField(
          labelText: 'Enter your Group\'s Name',
          key: _singleKeys[0],
          onSaved: (String value) => data.groupName = value,
          validator: (value) {
            if (value.isEmpty || value.length < 1) return 'Please enter Name';
            return null;
          },
        ));
  }

  Widget _getSepListView() {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return UserListTile(
            name: index + 1 <= friends.length ? friends[index] : null,
            trailing: IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () => setState(() => friends.removeAt(index)),
            ));
      },
      separatorBuilder: (context, index) {
        return Divider(color: Colors.black);
      },
      itemCount: friends.length,
    );
  }

  Step _getGroupMembersStep() {
    return Step(
        title: Text('Friend\'s'),
        isActive: true,
        content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          FormCreator.getTypeAheadFormField(
            key: _singleKeys[1],
            labelText: 'Choose your friends',
            suggestionCallBack: (pattern) =>
                ['Avi Israeli', 'Eli Israeli', 'Yossi Israeli'],
            onSuggestionSelected: (suggestion) {
              setState(() {
                friends.insert(0, suggestion);
                _friendsController.clear();
              });
            },
            validator: (value) {
              if (friends.isEmpty) return 'Please select Friend';
              return null;
            },
            onSaved: (value) => data.members.addAll(friends),
            controller: _friendsController,
          ),
          SizedBox(
            height: 150.0,
            width: 300.0,
            child: _getSepListView(),
          )
        ]));
  }

  Step _getDescriptionStep() {
    return Step(
        title: Text('Description'),
        isActive: true,
        content: FormCreator.getTextFormField(
          key: _singleKeys[2],
          labelText: 'Enter short description (optional)',
          maxLines: 4,
          onSaved: (value) => data.description = value,
        ));
  }

  Step _getPrivacyStep() {
    return Step(
        title: Text("private\\public"),
        isActive: true,
        content: TextSwitch(
          text: "would you like that people will see your group ?",
          switchValue: isPublic,
          onChanged: (bool value) {
            data.isPublic = value;
            setState(() => isPublic = value);
          },
        ));
  }

  Widget _controlsBuilder(BuildContext context,
      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    if (curr >= 3) {
      return Container(
        alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 50.0),
          child: IconTextButton(
        padding: EdgeInsets.all(3.0),
        text: 'Create!',
        icon: Icons.create,
        onPressed: () => {},
      ));
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20.0),
            child: IconTextButton(
              text: 'Back',
              onPressed: curr != 0 ? onStepCancel : null,
              padding: EdgeInsets.all(3.0),
              icon: Icons.arrow_upward,
            ),
          ),
          Container(
            margin: EdgeInsets.all(20.0),
            child: IconTextButton(
              padding: EdgeInsets.all(3.0),
              text: 'Next',
              onPressed: onStepContinue,
              icon: Icons.arrow_downward,
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    steps = <Step>[
      _getGroupNameStep(),
      _getGroupMembersStep(),
      _getDescriptionStep(),
      _getPrivacyStep()
    ];
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Stepper(
            type: StepperType.vertical,
            currentStep: curr,
            controlsBuilder: _controlsBuilder,
            onStepTapped: (step) {
              if (step <= curr)
                _goTo(step);
            },
            onStepCancel: _cancel,
            onStepContinue: _next,
            steps: steps,
          ),
        ],
      ),
    );
  }
}
