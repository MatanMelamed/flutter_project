import 'package:teamapp/models/records_list.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/services/general/utilites.dart';

class TeamsMetaData {
  String teamName;
  String description;
  String ownerUid;
  bool isPublic = true;
  List<User> friends = List();

  @override
  String toString() {
    String x = " ";
    for (User friend in friends) {
      x += " " + friend.firstName;
    }
    return "teamName: $teamName, description: $description,"
        "isPublic: $isPublic, ownerID: $ownerUid\n $x";
  }

  Team asTeam() {
    return Team.fromWithinApp(
      name: teamName,
      description: description,
      isPublic: isPublic,
      ownerUid: ownerUid,
    );
  }

  Future<Team> registerToDB() async {
    List<String> membersIds = friends.map((user) => user.uid).toList();
    membersIds.add(this.ownerUid);
    Team team = this.asTeam();
    return TeamDataManager.createTeam(
      team,
      await Utilities.loadImageFromAssetsAsFile("images/team.jpg"),
      usersList: RecordList.fromWithinApp(data: membersIds),
    );
  }
}
