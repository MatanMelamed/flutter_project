import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/location.dart';

class SearchAddresses extends StatefulWidget {
  State<StatefulWidget> createState() => _SearchAddressesState();
}

class _SearchAddressesState extends State<SearchAddresses> {
  GoogleMapController mapController;
  String _searchAddress;
  List<Marker> myMarkers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition:
                CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 10.0),
            //mapType: MapType.hybrid,
            markers: Set.from(myMarkers),
            onTap: _handleTap,
          ),
          Positioned(
            top: 30.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Enter Address',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: searchAndNavigate,
                        iconSize: 30.0)),
                onChanged: (val) {
                  setState(() {
                    _searchAddress = val;
                  });
                },
              ),
            ),
          ),
          Positioned(
              top: 100.0,
              right: 20.0,
              left: 340.0,
              child: SizedBox.fromSize(
                size: Size(10, 50), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.blueAccent, // button color
                    child: InkWell(
                      splashColor: Colors.green, // splash color
                      onTap: ()  {
                        _handleCurrentLocation();
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.my_location,
                            color: Colors.white,
                          ),
                          // icon
                        ],
                      ),
                    ),
                  ),
                ),
              )),
          Positioned(
              bottom: 30.0,
              right: 335.0,
              left: 15.0,
              child: SizedBox.fromSize(
                size: Size(56, 56), // button width and height
                child: ClipOval(
                  child: Material(
                    color: Colors.blueAccent, // button color
                    child: InkWell(
                      splashColor: Colors.green, // splash color
                      onTap: () async {
                        var location = await _handleAddLocationButton();
                        Navigator.of(context).pop(location);
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add_location,
                            color: Colors.white,
                          ),
                          // icon
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }


  void _handleCurrentLocation(){
    Geolocator().getCurrentPosition().then((result) {
      LatLng newPosition =
      LatLng(result.latitude, result.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: newPosition, zoom: 15.0)));
      _handleTap(newPosition);
    });
  }

  void searchAndNavigate() {
    print(_searchAddress);
    Geolocator().placemarkFromAddress(_searchAddress).then((result) {
      LatLng newPosition =
          LatLng(result[0].position.latitude, result[0].position.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: newPosition, zoom: 15.0)));
      _handleTap(newPosition);
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarkers = [];
      myMarkers.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true,
          onDragEnd: (dragEndPosition) {
            print(dragEndPosition);
          }));
    });
  }

  Future<Location> _handleAddLocationButton() async {
    if (myMarkers.isEmpty) {
      print("no address to save - error");
      return null;
    } else {
      LatLng location = myMarkers.elementAt(0).position;
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(location.latitude, location.longitude);
      return new Location(GeoPoint(location.latitude, location.longitude),
          _createAddress(placemark.elementAt(0)));
    }
  }

  String _createAddress(Placemark placemark) {
    String address = placemark.thoroughfare +
        " " +
        placemark.subThoroughfare + // street
        ", " +
        placemark.locality + // city
        ", " +
        placemark.country;
    print(address);
    return address;
  }



}
