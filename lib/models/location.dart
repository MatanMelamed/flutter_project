import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  GeoPoint location;
  String address;


  Location(this.location,this.address);

  GeoPoint geoPoint(){
    return this.location;
  }

  String getAddress(){
    return this.address;
  }
}