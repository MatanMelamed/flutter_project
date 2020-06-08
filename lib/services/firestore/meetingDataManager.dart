import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:teamapp/models/meeting.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/services/firestore/usersListDataManager.dart';

class MeetingDataManager {
  static final CollectionReference meetingsCollection = Firestore.instance.collection("meetings");

  static Future<Meeting> createMeeting({Team team, Meeting meeting}) async {
    //    DocumentReference meetingDocRef = await meetingsCollection.add({
    //      'name': meeting.name,
    //      'description': meeting.description,
    //      'status': EnumToString.parse(meeting.status),
    //      'time': meeting.time.toString(),
    //      'isPublic': meeting.isPublic,
    //    });

    UsersList ulAdd = UsersList.fromWithinApp(membersUids: ['try']);
    UsersListDataManager.createUsersList(ulAdd);

    ulAdd = UsersList.fromWithinApp(
      membersUids: ['fry'],
      metadata: {
        'fry': {
          'bool': false,
          'string': 'string',
          'int': 1,
        }
      },
    );
    UsersListDataManager.createUsersList(ulAdd);

    UsersList ulRetreive = await UsersListDataManager.getUsersList('mmrWqf4NC1EfsA3jfFF9');
    for (var uid in ulRetreive.membersUids) {
      if (ulRetreive.metadata.isEmpty) {
        print('no metadata');
      } else {
        print('metadata exists:');
        ulRetreive.metadata[uid]?.forEach((key, value) {
          print('key is: $key and value is: $value');
        });
      }
    }
  }
}
