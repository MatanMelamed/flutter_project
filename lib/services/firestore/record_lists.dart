import 'package:teamapp/services/firestore/baseListDataManager.dart';

class TeamToMeetings extends BaseListDataManager {
  static final TeamToMeetings _singleton = TeamToMeetings._internal();
  factory TeamToMeetings(){
    return _singleton;
  }
  TeamToMeetings._internal() : super("team_to_meetings", "meetings");
}

class UserToTeams extends BaseListDataManager {
  static final UserToTeams _singleton = UserToTeams._internal();
  factory UserToTeams(){
    return _singleton;
  }
  UserToTeams._internal() : super("user_teams", "teams");
}

class TeamToUsers extends BaseListDataManager {
  static final TeamToUsers _singleton = TeamToUsers._internal();
  factory TeamToUsers(){
    return _singleton;
  }
  TeamToUsers._internal() : super("team_to_users", "users");
}

class UserToMeetings extends BaseListDataManager {
  static final UserToMeetings _singleton = UserToMeetings._internal();
  factory UserToMeetings(){
    return _singleton;
  }
  UserToMeetings._internal() : super("user_to_meetigs", "meetings");
}

class MeetingToUsers extends BaseListDataManager {
  static final MeetingToUsers _singleton = MeetingToUsers._internal();
  factory MeetingToUsers(){
    return _singleton;
  }
  MeetingToUsers._internal() : super("meetig_to_users", "users");
}
