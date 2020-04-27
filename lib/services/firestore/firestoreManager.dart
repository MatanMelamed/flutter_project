import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:teamapp/models/storageImage.dart';

class StorageManager {
  static Future<StorageImage> saveImage(File image, String identification) async {
    final StorageReference storageRef = FirebaseStorage.instance.ref().child('/images/' + identification);
    final StorageUploadTask uploadTask = storageRef.putFile(image);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = downloadUrl.toString();
    String remotePath = storageRef.path.substring(1, storageRef.path.length - 4);
    print('remote path: $remotePath');
    return StorageImage(url: url, path: remotePath);
  }


  static Future<StorageImage> updateImage(File image, String identification) async {
    await deleteFile(identification);
    return saveImage(image, identification);
  }

  static Future<bool> deleteFile(String identification) async {
    final StorageReference storageRef = FirebaseStorage.instance.ref().child('/' + identification + '.jpg');
    storageRef.delete().then((_) {
      print('successfully deleted $identification file');
      return true;
    }).catchError((onError) {
      print('got error while trying to delete $identification,$onError');
      return false;
    });
  }

  static DateTime convertStringToDateTime(String dateTimeString) {
    return DateTime.parse(dateTimeString);
  }
}
