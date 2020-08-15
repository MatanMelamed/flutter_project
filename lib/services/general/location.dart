import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';


class LocationService {
  static Future<LatLng> getCurrentLocation() async {
    var result = await Geolocator().getCurrentPosition();
    return LatLng(result.latitude, result.longitude);
  }

  static double calculateTotalDistanceInKm(double lat1, double lon1, double lat2, double lon2) {
    final Distance distance = Distance();
    double totalDistanceInKm = distance.as(LengthUnit.Kilometer, LatLng(lat1, lon1), LatLng(lat2, lon2));
    return totalDistanceInKm;
  }

  static Future<double> distanceInKmFromUserLocation(double lat, double lon) async {
    var userLocation = await getCurrentLocation();
    return calculateTotalDistanceInKm(userLocation.latitude, userLocation.longitude, lat, lon);
  }
}
