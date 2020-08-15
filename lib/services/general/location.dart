import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService{
  static Future<LatLng> getCurrentLocation() async{
    var result = await Geolocator().getCurrentPosition();
    return LatLng(result.latitude, result.longitude);
  }
}