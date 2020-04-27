import 'package:flutter/material.dart';
import 'package:teamapp/services/firestore/firestoreManager.dart';
import 'package:teamapp/widgets/general/editViewImage.dart';

class AddImagesTester extends StatefulWidget {
  @override
  _AddImagesTesterState createState() => _AddImagesTesterState();
}

class _AddImagesTesterState extends State<AddImagesTester> {
  @override
  Widget build(BuildContext context) {
    return EditViewImage(
      onSaveNewImageFile: (file){
      },
    );
  }
}
