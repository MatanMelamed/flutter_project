import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowAddresses extends StatefulWidget {
  GeoPoint pointLocation;

  ShowAddresses(this.pointLocation);

  State<StatefulWidget> createState() => _ShowAddressesState();
}

class _ShowAddressesState extends State<ShowAddresses> {
  GoogleMapController mapController;
  List<Marker> myMarkers = [];

  @override
  void initState() {
    var tappedPoint =
        LatLng(widget.pointLocation.latitude, widget.pointLocation.longitude);
    _initMarker(tappedPoint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition:
                CameraPosition(target: LatLng(widget.pointLocation.latitude, widget.pointLocation.longitude), zoom: 10.0),
            //mapType: MapType.hybrid,
            markers: Set.from(myMarkers),
          ),
        ],
      ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _initMarker(LatLng tappedPoint) {
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
}
