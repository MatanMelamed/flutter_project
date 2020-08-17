import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/teams_meta_data.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/screens/group_creation/form_steps_manager.dart';
import 'package:teamapp/screens/teams/team_page.dart';
import 'package:teamapp/services/firestore/firestoreManager.dart';
import 'package:teamapp/services/firestore/searchByName/friends_suggestions.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';
import 'package:teamapp/services/general/utilites.dart';
import 'package:teamapp/widgets/dialogs/dialogs.dart';
import 'package:teamapp/widgets/group_creation/usefull_widgets.dart';

const NAME_STEP_ID = "Name";
const DESC_STEP_ID = "Description";
const FRIENDS_STEP_ID = "Friends";

class GroupCreation extends StatefulWidget {
  @override
  _GroupCreationState createState() => _GroupCreationState();
}

class _GroupCreationState extends State<GroupCreation> {
  List<Step> _steps;
  var _friendController = TextEditingController();
  var _curr = 0;
  var _teamsMeta = TeamsMetaData();
  var _manager = FormStepsManager()
      .addStepInfo(NAME_STEP_ID)
      .addStepInfo(DESC_STEP_ID)
      .addStepInfo(FRIENDS_STEP_ID);

  StepState getStepState(bool error) =>
      !error ? StepState.indexed : StepState.error;

  void goTo(int step) => setState(() => this._curr = step);

  void onContinue() {
    if (_curr + 1 < _steps.length) goTo(_curr + 1);
    this._manager.unFocusAll();
    this._manager.validateAndSave();
  }

  void onCancel() {
    if (_curr - 1 >= 0) goTo(_curr - 1);
    this._manager.unFocusAll();
  }

  showAlertDialog(BuildContext context) {
    Dialogs.showTwoButtonsDialog(
      context: context,
      firstButton: FlatButton(
        child: Text("OK"),
        onPressed: () => Navigator.of(context).pop(),
      ),
      secondButton: FlatButton(
        child: Text("Cancel"),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text("Error"),
      content: Text("Fix Errors and Try Again."),
    );
  }

  bool friendsContain(User friend) {
    for (User teamUser in _teamsMeta.friends)
      if (teamUser.uid == friend.uid) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var me = Provider.of<User>(context);
    this._teamsMeta.ownerUid = me.uid;
    this._steps = [
      Step(
        title: Text("Friends"),
        subtitle: Text("Add Friends To Your New Group"),
        isActive: true,
        state: getStepState(_manager.errorStateOf(FRIENDS_STEP_ID)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TypeAheadFormField<DocumentSnapshot>(
              key: _manager.keyOf(FRIENDS_STEP_ID),
              textFieldConfiguration: TextFieldConfiguration(
                focusNode: _manager.focusNodeOf(FRIENDS_STEP_ID),
                controller: _friendController,
              ),
              suggestionsCallback: (pattern) async {
                return await FriendsSuggester.getFriendsSuggestions(
                  _teamsMeta.ownerUid,
                  pattern,
                );
              },
              onSuggestionSelected: (doc) {
                _friendController.clear();
                var friend = UserDataManager.createUserFromDoc(doc);
                if (friendsContain(friend)) return;
                setState(() => _teamsMeta.friends.insert(0, friend));
              },
              itemBuilder: (context, doc) {
                return SuggestionTile(
                  title: FriendsSuggester.nameOf(doc),
                  image: FriendsSuggester.imageOf(doc),
                );
              },
              validator: (value) {
                if (_teamsMeta.friends.isEmpty) return "No Friends Entered";
                return null;
              },
              noItemsFoundBuilder: (context) {
                return Container(
                  alignment: const Alignment(0.0, 0.0),
                  height: 60.0,
                  child: Text(
                    "No Friends Found",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              height: 200.0,
              width: 300.0,
              child: ListView.separated(
                itemBuilder: (context, i) {
                  return SuggestionTile(
                    image: NetworkImage(_teamsMeta.friends[i].remoteImage.url),
                    title: i + 1 <= _teamsMeta.friends.length
                        ? _teamsMeta.friends[i].firstName
                        : null,
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() => _teamsMeta.friends.removeAt(i));
                      },
                    ),
                  );
                },
                separatorBuilder: (context, i) => Divider(
                  color: Colors.black,
                ),
                itemCount: _teamsMeta.friends.length,
              ),
            ),
          ],
        ),
      ),
      Step(
        title: Text("Team's Name"),
        subtitle: Text("Choose A Cool Name For Your Group"),
        isActive: true,
        state: getStepState(_manager.errorStateOf(NAME_STEP_ID)),
        content: TextFormField(
          key: _manager.keyOf(NAME_STEP_ID),
          focusNode: _manager.focusNodeOf(NAME_STEP_ID),
          validator: (str) {
            if (str.isEmpty) return "No Name Found";
            return null;
          },
          onSaved: (value) => this._teamsMeta.teamName = value,
        ),
      ),
      Step(
        title: Text("Team's Description"),
        subtitle: Text("Add Short Description For your Team (Optional)"),
        isActive: true,
        state: getStepState(_manager.errorStateOf(DESC_STEP_ID)),
        content: TextFormField(
          key: _manager.keyOf(DESC_STEP_ID),
          focusNode: _manager.focusNodeOf(DESC_STEP_ID),
          validator: (str) => null,
          onSaved: (value) => this._teamsMeta.description = value,
        ),
      ),
      Step(
        title: Text("Private\\Public"),
        isActive: true,
        content: TextSwitch(
          text: "would you like that people will see your group ?",
          switchValue: _teamsMeta.isPublic,
          onChanged: (bool value) {
            setState(() => _teamsMeta.isPublic = value);
          },
        ),
      ),
    ];
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Stepper(
            type: StepperType.vertical,
            steps: _steps,
            currentStep: _curr,
            onStepContinue: onContinue,
            onStepCancel: onCancel,
            onStepTapped: goTo,
          ),
          IconTextButton(
            icon: Icons.check,
            text: "Let's Go !",
            color: Colors.blueAccent,
            padding: EdgeInsets.all(2.0),
            radius: BorderRadius.circular(18.0),
            onPressed: () async {
              print(_teamsMeta);
              if (!_manager.validateAndSave() || _teamsMeta.friends.isEmpty)
                showAlertDialog(context);
              else {
                var newTeam = await _teamsMeta.registerToDB();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TeamPage(team: newTeam),
                  ),
                );
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
