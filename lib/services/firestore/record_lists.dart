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
  static const String USERS_COUNT = 'SIZE';
  static bool DEF_APPROVAL = false;

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
    super.createRecordList(recordList: recordList, documentName: documentName);

    updateUsersCount(documentName, recordList.data.length);
  }

  void updateUsersCount(String mid, int newValue) {
    recordsListCollection.document(mid).updateData({USERS_COUNT: newValue});
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
    updateUsersCount(lid, docSnap.data[USERS_COUNT] + 1);
  }

  Future<void> updateUserApproval(String mid, String uid, bool newApproval) async {
    updateRecordMetadata(mid, uid, {USER_APPROVAL_STATUS: newApproval});
  }

  @override
  Future<void> removeRecord(String lid, String record) async {
    super.removeRecord(lid, record);
    DocumentSnapshot docSnap = await recordsListCollection.document(lid).get();
    updateUsersCount(lid, docSnap.data[USERS_COUNT] - 1);
  }
}
