import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/storageImage.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/services/firestore/firestoreManager.dart';


class UserDataManager {
  static final CollectionReference usersCollection =
      Firestore.instance.collection("users");

  static Future<User> createUser(User user, File userImage) async {
    var data = {
      'email': user.email,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'birthday': user.birthday.toString(),
      'gender': user.gender,
      'searchKey': user.firstName.substring(0, 1).toUpperCase()
    };

    // create a ref to be created
    DocumentReference docRef = usersCollection.document(user.uid);

    // set new user with it's data
    await docRef.setData(data);

    // add image
    StorageImage image = await StorageManager.saveImage(userImage, user.uid);

    // update image remote details for usage and future changes.
    docRef.updateData({'imageUrl': image.url, 'imagePath': image.path});

    // return the full user
    return User.fromDatabase(
        email: user.email,
        uid: user.uid,
        remoteImage: image,
        firstName: user.firstName,
        lastName: user.lastName,
        gender: user.gender,
        birthday: user.birthday);
  }

  static Future<User> getUser(String uid) async {
    User user;
    DocumentSnapshot docSnap = await usersCollection.document(uid).get();

    if (docSnap.exists) {
      Map<String, dynamic> data = docSnap.data;
      user = new User.fromDatabase(
        email: data['email'],
          uid: docSnap.documentID,
          remoteImage:
              StorageImage(url: data['imageUrl'], path: data['imagePath']),
          firstName: data['first_name'],
          lastName: data['last_name'],
          gender: data['gender'],
          birthday: StorageManager.convertStringToDateTime(data['birthday']));
    } else {
      print('Tried to get nonexistent user id');
    }

    return user;
  }

  static Future<User> updateUser(User user, File userImage) async{
    var data = {
      'first_name': user.firstName,
      'last_name': user.lastName,
      'birthday': user.birthday.toString(),
      'gender': user.gender,
      'searchKey': user.firstName.substring(0, 1).toUpperCase()
    };

    // create a ref to be created
    DocumentReference docRef = usersCollection.document(user.uid);

    // set new user with it's data
    await docRef.updateData(data);
    StorageImage image;
    if(userImage != null) {
      // update image
      image = await StorageManager.updateStorageImage(
          userImage, user.remoteImage);

      // update image remote details for usage and future changes.
      docRef.updateData({'imageUrl': image.url, 'imagePath': image.path});
    }
    else{
      image = user.remoteImage;
    }
    // return the full user
    return User.fromDatabase(
        uid: user.uid,
        remoteImage: image,
        firstName: user.firstName,
        lastName: user.lastName,
        gender: user.gender,
        birthday: user.birthday);
  }

  static User createUserFromDoc(DocumentSnapshot docSnap) {
    Map<String, dynamic> data = docSnap.data;
    var user = new User.fromDatabase(
        email: data['email'],
        uid: docSnap.documentID,
        remoteImage:
        StorageImage(url: data['imageUrl'], path: data['imagePath']),
        firstName: data['first_name'],
        lastName: data['last_name'],
        gender: data['gender'],
        birthday: StorageManager.convertStringToDateTime(data['birthday']));
    return user;
  }

}
