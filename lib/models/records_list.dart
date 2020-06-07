import 'package:flutter/material.dart';

class RecordList {
  String lid;
  List<String> data;

  // each user can have metadata in the form of a map from value name to value,
  // for example user may have metadata of { 'status' : <bool type>, 'name': <string type>, ...}
  Map<String, Map<String, dynamic>> metadata;

  RecordList.fromDatabase({
    @required this.lid,
    @required this.data,
    @required this.metadata,
  });

  RecordList.fromWithinApp({this.data, this.metadata}) {
    data = data ?? [];
    // create empty metadata for all users if none received.
    if (metadata == null) {
      metadata = {};
      for (String record in data) {
        metadata[record] = {};
      }
    }
  }

  addRecord(String newRecord, {Map<String, dynamic> metadata}) {
    data.add(newRecord);
    metadata[newRecord] = metadata;
  }
}
