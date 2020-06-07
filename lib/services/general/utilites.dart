import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Utilities {
  static Future<File> loadImageFromAssetsAsFile(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/default_profile_image.png');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}

extension StringExtension on String {
  String capitalizeOnlyFirst() {
    return "${this.toLowerCase()[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension ToString on DateTime {
  String toDisplayString() {
    return formatDate(this, [dd, '-', mm, '-', yyyy]);
  }
}
