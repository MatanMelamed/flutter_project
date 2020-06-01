import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:teamapp/models/storageImage.dart';

class StorageManager {
  static Future<StorageImage> saveImage(File image, String idPath) async {
    final StorageReference storageRef = FirebaseStorage.instance.ref().child('/images/' + idPath);
    final StorageUploadTask uploadTask = storageRef.putFile(image);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = downloadUrl.toString();
    return StorageImage(url: url, path: idPath);
  }

  static Future<StorageImage> updateStorageImage(File image, StorageImage storageImage) async {
    await deleteFile(storageImage.url);
    return saveImage(image, storageImage.path);
  }

  static Future<bool> deleteFile(String url) async {
    StorageReference photoRef = await FirebaseStorage.instance.getReferenceFromUrl(url);
    photoRef.delete().then((_) {
      print('Successfully deleted $url');
      return true;
    }).catchError((error) {
      print('failed to delete $url,\n$error');
      return false;
    });
  }

  static DateTime convertStringToDateTime(String dateTimeString) {
    return DateTime.parse(dateTimeString);
  }
}
