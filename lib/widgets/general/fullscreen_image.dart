import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:teamapp/services/general/imagery.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class FullScreenImage extends StatefulWidget {
  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  String def_img = "assets/images/team.jpg";

  File _selectedFile;
  bool inProcess;

  getImage(ImageSource source) async {
    setState(() {
      inProcess = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          cropStyle: CropStyle.circle,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.blue,
              toolbarTitle: "Android title",
              statusBarColor: Colors.blue.shade900,
              backgroundColor: Colors.white));
      this.setState(() {
        _selectedFile = cropped;
        inProcess = false;
      });
    } else {
      setState(() {
        inProcess = false;
      });
    }
  }

  Widget EditMode() {
    print(_selectedFile == null);
    return Container(
      decoration: BoxDecoration(color: Colors.green),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                //child: Image(image: _selectedFile == null ? AssetImage(def_img) : FileImage(_selectedFile)),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: _selectedFile == null ? AssetImage(def_img) : FileImage(_selectedFile),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(150)),
                  border: Border.all(color: Colors.black45, width: 2),
                ),
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
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                  color: Colors.grey[400],
                  child: Icon(Icons.photo_camera),
                ),
                RaisedButton(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
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
    return SafeArea(child: EditMode());
  }
}
