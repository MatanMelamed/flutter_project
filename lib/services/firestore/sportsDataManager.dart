import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:teamapp/models/sport.dart';

class SportsDataManager {
  static final CollectionReference sportsCollection = Firestore.instance.collection("sports");

  static void firstRun() {
    create("Aerobic", "CrossFit");
    create("BallSport", "BasketBall");
    create("BodyBuilding", "WeightLifting");
  }

  static void create(String type, String sport) async {
    var ref = await sportsCollection.document(type);
    ref.setData({
      EnumToString.parse(SportField.SUB_SPORT): sport,
    });
  }

  static Sport convertSnapshotToSport(DocumentSnapshot doc) {
    return Sport(
      type: EnumToString.fromString(
        SportType.values,
        doc.documentID,
      ),
      sport: EnumToString.fromString(
        SubSport.values,
        doc.data[EnumToString.parse(SportField.SUB_SPORT)],
      ),
    );
  }

  static Future<List<Sport>> getAllSports() async {
    List<Sport> sports = [];
    QuerySnapshot allSports = await sportsCollection.getDocuments();
    for (var sportSnap in allSports.documents) {
      sports.add(convertSnapshotToSport(sportSnap));
    }
    return sports;
  }
}
