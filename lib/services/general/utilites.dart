import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Utilities {
  static Future<File> loadImage(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/default_profile_img.png');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
