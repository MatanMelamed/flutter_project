import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserManagement {
  final CollectionReference usersCollections =
      Firestore.instance.collection('users');

  final String uid;

  UserManagement({this.uid});

  Future signUpUserData(
      String fullname, DateTime birthday, String gender, File image) async {
    var url = await UserManagement(uid: this.uid).saveProfileImage(image);
    print(url);
    return usersCollections.document(uid).setData({
      'uid': uid,
      'fullname': fullname,
      'birthday': birthday.toString(),
      'gender': gender,
      'imageurl': url
    });
  }

  DateTime convertStringToDateTime(String dateTimeString) {
    return DateTime.parse(dateTimeString);
  }

  Stream<UserData> get user {
    return usersCollections.document(uid).snapshots().map(_userFromSnapshot);
  }

  UserData _userFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        fullname: snapshot.data['fullname'] ?? '',
        gender: snapshot.data['gender'] ?? '',
        birthday: convertStringToDateTime(snapshot.data['birthday']) ??
            DateTime.now(),
        uid: snapshot.data['uid'] ?? '' ,
        imageurl: snapshot.data['imageurl']
    );
  }

  Future<String> saveProfileImage(File image) async {
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('/' + uid + '.jpg');
    final StorageUploadTask uploadTask = storageRef.putFile(image);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();

    return url;
  }
}
