import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:teamapp/models/meeting.dart';
import 'package:teamapp/models/records_list.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/usersList.dart';
import 'package:teamapp/services/firestore/baseListDataManager.dart';
import 'package:teamapp/services/firestore/record_lists.dart';
import 'package:teamapp/services/firestore/teamDataManager.dart';
import 'package:teamapp/services/firestore/usersListDataManager.dart';

/*
  Meetings databases contain:
    Meeting - saves each meeting's data,
    UsersList - all the users in the meeting + metadata containing their approval status
    UserToMeeting - saves all meetings of a user under a doc for fast retrieve
 */
class MeetingDataManager {
  static final CollectionReference meetingsCollection = Firestore.instance.collection("meetings");
  static const String USER_APPROVAL_STATUS = 'approval_status';

  static UserToMeetings userToMeetings = UserToMeetings();
  static TeamToMeetings teamToMeetings = TeamToMeetings();
  static MeetingToUsers meetingToUsers = MeetingToUsers();

  static Future<void> _createUsersListForMeeting(Team team, String mid) async {
    Map<String, Map<String, dynamic>> metadata = {};

    // get the users of the team
    RecordList users_in_team = await TeamToUsers().getRecordsList(team.tid);

    // create metadata per user in team's users list
    for (String uid in users_in_team.data) {
      metadata[uid] = {USER_APPROVAL_STATUS: false};
    }

    // create meeting's users list with the metadata
    RecordList meetingUl = RecordList.fromWithinApp(data: users_in_team.data, metadata: metadata);

    // save the meeting's users list in firestore
    meetingToUsers.createRecordList(recordList: meetingUl, documentName: mid);
  }

  static Future<Meeting> createMeeting(Team team, Meeting meeting) async {
    DocumentReference meetingDocRef = await meetingsCollection.add({
      EnumToString.parse(MeetingField.NAME): meeting.name,
      EnumToString.parse(MeetingField.DESCRIPTION): meeting.description,
      EnumToString.parse(MeetingField.STATUS): EnumToString.parse(meeting.status),
      EnumToString.parse(MeetingField.TIME): meeting.time.toString(),
      EnumToString.parse(MeetingField.IS_PUBLIC): meeting.isPublic,
      EnumToString.parse(MeetingField.AGE_LIMIT_START): meeting.ageLimitStart,
      EnumToString.parse(MeetingField.AGE_LIMIT_END): meeting.ageLimitEnd,
      EnumToString.parse(MeetingField.LOCATION): meeting.location,
      EnumToString.parse(MeetingField.SPORT): meeting.sport,
      EnumToString.parse(MeetingField.TID): team.tid
    });

    // create a users list with metadata per user - approval status<bool>
    await _createUsersListForMeeting(team, meetingDocRef.documentID);
    TeamToMeetings().addRecord(team.tid, meetingDocRef.documentID);

    meetingDocRef.updateData({
      EnumToString.parse(MeetingField.MID): meetingDocRef.documentID,
    });

    return Meeting.fromDatabase(
      mid: meetingDocRef.documentID,
      tid: team.tid,
      name: meeting.name,
      description: meeting.description,
      status: meeting.status,
      time: meeting.time,
      isPublic: meeting.isPublic,
      ageLimitStart: meeting.ageLimitStart,
      ageLimitEnd: meeting.ageLimitEnd,
      location: meeting.location,
      sport: meeting.sport,
    );
  }

  static Future<void> deleteMeetingByMID(String mid) async {
    DocumentSnapshot meetingSnap = await meetingsCollection.document(mid).get();

    // remove meeting from user to meetings tracking
    RecordList usersInMeeting = await meetingToUsers.getRecordsList(mid);

    for (String uid in usersInMeeting.data) {
      userToMeetings.removeRecord(uid, mid);
    }

    meetingToUsers.deleteRecordsList(mid);

    teamToMeetings.removeRecord(meetingSnap.data[MeetingField.TID], mid);

    await meetingsCollection.document(mid).delete();
  }

  static Future<Meeting> convertDocToMeeting(DocumentSnapshot docSnap) async {
    Meeting meeting;
    if (docSnap.exists) {
      Map<String, dynamic> data = docSnap.data;
      meeting = new Meeting.fromDatabase(
        mid: data[EnumToString.parse(MeetingField.MID)],
        tid: data[EnumToString.parse(MeetingField.TID)],
        name: data[EnumToString.parse(MeetingField.NAME)],
        description: data[EnumToString.parse(MeetingField.DESCRIPTION)],
        status: EnumToString.fromString(
          MeetingStatus.values,
          data[EnumToString.parse(MeetingField.STATUS)],
        ),
        time: DateTime.parse(data[EnumToString.parse(MeetingField.TIME)]),
        isPublic: data[EnumToString.parse(MeetingField.IS_PUBLIC)],
        ageLimitStart: data[EnumToString.parse(MeetingField.AGE_LIMIT_START)],
        ageLimitEnd: data[EnumToString.parse(MeetingField.AGE_LIMIT_END)],
        location: data[EnumToString.parse(MeetingField.LOCATION)],
        sport: data[EnumToString.parse(MeetingField.SPORT)],
      );
    } else {
      print('Tried to get nonexistent team id');
    }

    return meeting;
  }

  static Future<Meeting> getMeetingByMID(String mid) async {
    DocumentSnapshot docSnap = await meetingsCollection.document(mid).get();
    return convertDocToMeeting(docSnap);
  }

  // changes after creation
  static Future<void> updateMeetingField(Meeting meeting, MeetingField field, dynamic newValue) async {
    meeting.propAccess(field, newValue: newValue);
    DocumentReference docRef = meetingsCollection.document(meeting.mid);
    await docRef.updateData({EnumToString.parse(field): newValue});
  }

  static Future<void> userRemovedFromTeam(String tid, String uid) async {
    RecordList teamsMeetings = await teamToMeetings.getRecordsList(tid);
    for (String mid in teamsMeetings.data) {
      await removeUserFromMeeting(mid, uid);
    }
  }

  static Future<void> userAddedToTeam(String tid, String uid) async {
    RecordList teamsMeetings = await teamToMeetings.getRecordsList(tid);
    for (String mid in teamsMeetings.data) {
      await addUserToMeeting(mid, uid);
    }
  }

  static Future<void> addUserToMeeting(String mid, String uid) async {
    await userToMeetings.addRecord(uid, mid);
    await meetingToUsers.addRecord(mid, uid, metadata: {USER_APPROVAL_STATUS: false});
  }

  static Future<void> removeUserFromMeeting(String mid, String uid) async {
    await userToMeetings.removeRecord(uid, mid);
    await meetingToUsers.removeRecord(mid, uid);
  }

  static void clearAllMeetings() async {
    QuerySnapshot allMeetingsSnapshot = await meetingsCollection.getDocuments();
    for (var meetingSnap in allMeetingsSnapshot.documents) {
      deleteMeetingByMID(meetingSnap.documentID);
    }
  }

  static Future<List<Meeting>> getAllMeetingsOfATeam(String tid) async {
    List<Meeting> meetings = [];
    RecordList meetingsRecordList = await TeamToMeetings().getRecordsList(tid);
    for (String mid in meetingsRecordList.data) {
      meetings.add(await getMeetingByMID(mid));
    }
    return meetings;
  }
}
