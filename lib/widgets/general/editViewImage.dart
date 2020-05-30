import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

enum EditViewImageMode { ViewOnly, ViewAndEdit }

class EditViewImage extends StatefulWidget {
  final ImageProvider imageProvider;
  final void Function(File) onSaveNewImageFile;
  final String heroTag;
  final EditViewImageMode mode;

  final String defaultAsset;

  EditViewImage(
      {this.imageProvider,
      this.onSaveNewImageFile,
      this.heroTag = "",
      this.defaultAsset = "assets/images/team.jpg",
      this.mode = EditViewImageMode.ViewAndEdit});

  @override
  _EditViewImageState createState() => _EditViewImageState();
}

class _EditViewImageState extends State<EditViewImage> {
  ImageProvider imageProvider;
  Function(File) onSave;

  bool inProcess;
  bool isInEditMode = true;

  @override
  void initState() {
    imageProvider = widget.imageProvider ?? AssetImage(widget.defaultAsset);
    onSave = widget.onSaveNewImageFile ?? (file) {};
    super.initState();
  }

  void getImageFromSource(ImageSource source) async {
    setState(() {
      inProcess = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          cropStyle: CropStyle.rectangle,
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
        // save image
        if (cropped != null) {
          onSave(cropped);
          imageProvider = FileImage(cropped);
        }
        inProcess = false;
      });
    } else {
      setState(() {
        inProcess = false;
      });
    }
  }

  Widget getImage(double width, double height) {
    return widget.heroTag != ""
        ? Hero(
            tag: widget.heroTag,
            child: Image(
              width: width,
              height: height,
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          )
        : Image(
            width: width,
            height: height,
            image: imageProvider,
            fit: BoxFit.cover,
          );
  }

  void toggleView() {
    setState(() {
      isInEditMode = !isInEditMode;
      print("changed to " + (isInEditMode ? "edit" : "view") + " mode ");
    });
  }

  Widget editMode() {
    return Column(
      children: <Widget>[
        Spacer(),
        Container(
            padding: EdgeInsets.all(30),
            //decoration: BoxDecoration(border: Border.all(color: Colors.black87)),
            child: getImage(250, 250)),
        widget.mode == EditViewImageMode.ViewOnly
            ? Container()
            : SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        getImageFromSource(ImageSource.camera);
                      },
                      color: Colors.grey[400],
                      child: Icon(Icons.photo_camera),
                    ),
                    RaisedButton(
                      onPressed: () {
                        getImageFromSource(ImageSource.gallery);
                      },
                      color: Colors.grey[400],
                      child: Icon(Icons.file_upload),
                    ),
                  ],
                ),
              ),
        Spacer()
      ],
    );
  }

  Widget viewMode() {
    return Container(
      child: PhotoView(
        backgroundDecoration: BoxDecoration(color: Colors.black, border: Border.all(color: Colors.black87)),
        imageProvider: imageProvider,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isInEditMode
        ? Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: GestureDetector(onTap: toggleView, child: editMode()),
            ),
          )
        : SafeArea(
            child: GestureDetector(onTap: toggleView, child: viewMode()),
          );
  }
}
