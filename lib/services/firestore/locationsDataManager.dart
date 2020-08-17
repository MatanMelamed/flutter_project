import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart';

class LocationsDataManagers {
  static final double MaxDis = 10.0;
  static final CollectionReference teamsLocationCollection =
      Firestore.instance.collection("team_location");

  Future<void> addTeamLocation(
      String teamId, double latitude, double longitude, String address) async {
    teamsLocationCollection.document(teamId).setData(
        {"location": new GeoPoint(latitude, longitude), "address": address});
  }

  static double calculateTotalDistanceInKm(double userLatitude, double userLongitude,
      double teamLatitude, double teamLongitude) {
    final Distance distance = Distance();

    double totalDistanceInKm = distance.as(
        LengthUnit.Kilometer,
        LatLng(userLatitude, userLongitude),
        LatLng(teamLatitude, teamLongitude));

    return totalDistanceInKm;
  }

  static Future<List<String>> getTeamIdAtMaxDis(
      double userLatitude, double userLongitude) async {
    List<String> teamsId = [];
    QuerySnapshot teamsLocation = await teamsLocationCollection.getDocuments();

    for (DocumentSnapshot docSnap in teamsLocation.documents) {
      GeoPoint teamLocation = docSnap.data["location"];
      double distance = calculateTotalDistanceInKm(userLatitude, userLongitude, teamLocation.latitude, teamLocation.longitude);
      if(distance <= MaxDis)
        teamsId.add(docSnap.documentID);
    }
    return teamsId;
  }


}
