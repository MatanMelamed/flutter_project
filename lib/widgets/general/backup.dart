import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:teamapp/services/general/imagery.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class FullScreenImagee extends StatefulWidget {
  @override
  _FullScreenImageeState createState() => _FullScreenImageeState();
}

class _FullScreenImageeState extends State<FullScreenImagee> {
  String def_img = "assets/images/team.jpg";

  File _image;

  bool isViewMode = false;

  void ToggleView() {
    setState(() {
      isViewMode = !isViewMode;

      print("changed to " + (isViewMode ? "view" : "edit") + " mode ");
    });
  }

  Widget ViewMode() {
    return Material(
      child: InkWell(
        onTap: ToggleView,
        child: PhotoView(
          imageProvider: _image == null ? AssetImage(def_img) : FileImage(_image),
          ),
        ),
      );
  }

  Widget EditMode() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          Material(
            child: InkWell(
              onTap: ToggleView,
              child: Container(
                child: ClipRect(child: _image == null ? Image.asset(def_img) : Image.file(_image)),
                ),
              ),
            ),
          SizedBox(
            height: 25,
            ),

          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {},
                  color: Colors.grey[400],
                  child: Icon(Icons.photo_camera),
                  ),
                RaisedButton(
                  onPressed: () {},
                  color: Colors.grey[400],
                  child: Icon(Icons.file_upload),
                  ),

              ],
              ),
            )
        ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isViewMode ? ViewMode() : EditMode(),
      );
  }
}
