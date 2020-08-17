import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/widgets/authenticate/inputs.dart';
import 'package:teamapp/widgets/loading.dart';
import 'package:teamapp/widgets/teams/team_card.dart';

class SearchTeamPage extends StatefulWidget {
  @override
  _SearchTeamPageState createState() => _SearchTeamPageState();
}

class _SearchTeamPageState extends State<SearchTeamPage> {
  TextEditingController _prefix;
  List<Team> _suggested;
  String check;

  @override
  void initState() {
    super.initState();
    this._prefix = TextEditingController();
    this._suggested = List();
  }

  InputDecoration _getDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.all(15.0),
      alignLabelWithHint: true,
      hintText: 'Search Teams',
    );
  }

  Widget getBuilder(
    BuildContext context,
    AsyncSnapshot<dynamic> snapshot,
  ) {
    return !snapshot.hasData
        ? Loading()
        : ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (_, i) {
              return snapshot.data.isNotEmpty
                  ? TeamCard(
                      team: snapshot.data[i],
                onTap: () async {
                        // TODO: Eyal's alert dialog
                },
                    )
                  : Text("ERROR");
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Teams'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: this._prefix,
              onChanged: (value) => setState(() {}),
              decoration: this._getDecoration(),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: TeamDataManager.fromPrefix(_prefix.text),
                    builder: getBuilder,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
