import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/records_list.dart';
import 'package:teamapp/services/firestore/baseListDataManager.dart';

class TeamToMeetings extends BaseListDataManager {
  static final TeamToMeetings _singleton = TeamToMeetings._internal();

  factory TeamToMeetings() {
    return _singleton;
  }

  TeamToMeetings._internal() : super("team_to_meetings", "meetings");
}

class UserToTeams extends BaseListDataManager {
  static final UserToTeams _singleton = UserToTeams._internal();

  factory UserToTeams() {
    return _singleton;
  }

  UserToTeams._internal() : super("user_teams", "teams");
}

class TeamToUsers extends BaseListDataManager {
  static final TeamToUsers _singleton = TeamToUsers._internal();
  static final String AUTO_JOIN_NEW_MEETINGS = "AUTO_JOIN";
  static final bool AUTO_JOIN_DEF = true;

  factory TeamToUsers() {
    return _singleton;
  }

  TeamToUsers._internal() : super("team_to_users", "users");

  @override
  Future<RecordList> createRecordList({RecordList recordList, String documentName}) async {
    // add metadata to each user
    for (String uid in recordList.data) {
      recordList.metadata[uid] = {AUTO_JOIN_NEW_MEETINGS: AUTO_JOIN_DEF};
    }
    super.createRecordList(recordList: recordList, documentName: documentName);
  }

  Future<void> updateUserAutoJoin(String tid, String uid, bool newAutoJoin) async {
    updateRecordMetadata(tid, uid, {AUTO_JOIN_NEW_MEETINGS: newAutoJoin});
  }

  Future<bool> isUserAutoJoin(String tid, String uid) async {
    DocumentSnapshot docSnap =
        await recordsListCollection.document(tid).collection(subCollectionName).document(uid).get();
    return docSnap.data[AUTO_JOIN_NEW_MEETINGS];
  }

  @override
  Future<bool> addRecord(String lid, String record, {Map<String, dynamic> metadata}) async {
    if (metadata == null) {
      metadata = {AUTO_JOIN_NEW_MEETINGS: AUTO_JOIN_DEF};
    } else if (!metadata.containsKey(AUTO_JOIN_NEW_MEETINGS)) {
      metadata[AUTO_JOIN_NEW_MEETINGS] = AUTO_JOIN_DEF;
    }
    super.addRecord(lid, record, metadata: metadata);
  }
}

class UserToMeetings extends BaseListDataManager {
  static final UserToMeetings _singleton = UserToMeetings._internal();

  factory UserToMeetings() {
    return _singleton;
  }

  UserToMeetings._internal() : super("user_to_meetigs", "meetings");
}

class MeetingToUsers extends BaseListDataManager {
  static final MeetingToUsers _singleton = MeetingToUsers._internal();
  static const String USER_APPROVAL_STATUS = 'approval_status';
  static const String USERS_COUNTER = 'SIZE';
  static const String APPROVED_COUNTER = 'APPROVED';
  static const bool DEF_APPROVAL = false;

  factory MeetingToUsers() {
    return _singleton;
  }

  MeetingToUsers._internal() : super("meetig_to_users", "users");

  @override
  Future<RecordList> createRecordList({RecordList recordList, String documentName}) async {
    // add metadata to each user
    for (String uid in recordList.data) {
      recordList.metadata[uid] = {USER_APPROVAL_STATUS: DEF_APPROVAL};
    }

    RecordList list = await super.createRecordList(recordList: recordList, documentName: documentName);

    updateUsersCounter(documentName, recordList.data.length);
    updateUsersCounter(documentName, DEF_APPROVAL ? recordList.data.length : 0);

    return list;
  }

  Future<bool> isUserInMeeting(String mid, String uid) async{
    var doc = await recordsListCollection.document(mid).collection(subCollectionName).document(uid).get();
    return doc.exists;
  }

  Future<bool> isUserApproved(String mid, String uid) async {
    var doc = await recordsListCollection.document(mid).collection(subCollectionName).document(uid).get();
    return doc[USER_APPROVAL_STATUS];
  }

  Future<List> getCounters(String mid) async {
    DocumentSnapshot docSnap = await recordsListCollection.document(mid).get();
    return [docSnap.data[USERS_COUNTER], docSnap.data[APPROVED_COUNTER]];
  }

  void updateUsersApprovedCounter(String mid, int newValue) {
    recordsListCollection.document(mid).updateData({APPROVED_COUNTER: newValue});
  }

  void updateUsersCounter(String mid, int newValue) {
    recordsListCollection.document(mid).updateData({USERS_COUNTER: newValue});
  }

  @override
  Future<bool> addRecord(String lid, String record, {Map<String, dynamic> metadata}) async {
    if (metadata == null) {
      metadata = {USER_APPROVAL_STATUS: DEF_APPROVAL};
    } else if (!metadata.containsKey(USER_APPROVAL_STATUS)) {
      metadata[USER_APPROVAL_STATUS] = DEF_APPROVAL;
    }
    super.addRecord(lid, record, metadata: metadata);

    DocumentSnapshot docSnap = await recordsListCollection.document(lid).get();
    updateUsersCounter(lid, docSnap.data[USERS_COUNTER] + 1);
    if (DEF_APPROVAL) {
      updateUsersApprovedCounter(lid, docSnap.data[APPROVED_COUNTER] + 1);
    }
  }

  Future<void> updateUserApproval(String mid, String uid, bool newApproval) async {
    updateRecordMetadata(mid, uid, {USER_APPROVAL_STATUS: newApproval});
    if (newApproval) {
      DocumentSnapshot docSnap = await recordsListCollection.document(mid).get();
      updateUsersApprovedCounter(mid, docSnap.data[APPROVED_COUNTER] + 1);
    } else {
      DocumentSnapshot docSnap = await recordsListCollection.document(mid).get();
      updateUsersApprovedCounter(mid, docSnap.data[APPROVED_COUNTER] - 1);
    }
  }

  @override
  Future<void> removeRecord(String lid, String record) async {
    var userDoc = await recordsListCollection.document(lid).collection(subCollectionName).document(record).get();
    DocumentSnapshot docSnap = await recordsListCollection.document(lid).get();
    updateUsersCounter(lid, docSnap.data[USERS_COUNTER] - 1);
    if (userDoc.data[USER_APPROVAL_STATUS]) {
      updateUsersApprovedCounter(lid, docSnap.data[APPROVED_COUNTER]-1);
    }
    super.removeRecord(lid, record);
  }
}
