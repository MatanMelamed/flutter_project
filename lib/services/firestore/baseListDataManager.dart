import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/records_list.dart';

class BaseListDataManager {
  final String collectionName;
  final String subCollectionName;
  CollectionReference recordsListCollection;

  BaseListDataManager(this.collectionName, this.subCollectionName) {
    recordsListCollection = Firestore.instance.collection(collectionName);
  }

  Future<RecordList> createRecordList({RecordList recordList, String documentName}) async {
    print('creating record list with ${documentName ?? 'no name'}');
    DocumentReference docRef =
        documentName == null ? recordsListCollection.document() : recordsListCollection.document(documentName);
    docRef.setData({});

    recordList = recordList ?? RecordList.fromWithinApp();

    for (var i = 0; i < recordList.data.length; i++) {
      String record = recordList.data[i];
      DocumentReference userDocRef = docRef.collection(subCollectionName).document(record);
      userDocRef.setData(recordList.metadata[record] ?? {});
    }

    return RecordList.fromDatabase(
      lid: docRef.documentID,
      data: recordList.data,
      metadata: recordList.metadata,
    );
  }

  Future<bool> addRecord(String lid, String record, {Map<String, dynamic> metadata}) async {
    DocumentSnapshot listSnapshot = await recordsListCollection.document(lid).get();

    if (!listSnapshot.exists) {
      listSnapshot.reference.setData({});
    }

    return listSnapshot.reference
        .collection(subCollectionName)
        .document(record)
        .setData(metadata ?? {})
        .then((_) => true)
        .catchError((error) {
      print('error in add record $record to record list $lid.');
      return false;
    });
  }

  Future<void> updateRecordMetadata(String lid, String record, Map<String, dynamic> metadata) async {
    await recordsListCollection.document(lid).collection(subCollectionName).document(record).updateData(metadata);
  }

  Future<void> removeRecord(String lid, String record) async {
    print('Remove record in $collectionName :: remove $record in $lid');
    await recordsListCollection.document(lid).collection(subCollectionName).document(record).delete();
  }

  Future<RecordList> getRecordsList(String lid) async {
    RecordList recordList;

    // ref to doc in firestore database, may not exist
    DocumentReference ulReference = recordsListCollection.document(lid);

    // the doc itself
    DocumentSnapshot ulSnapshot = await ulReference.get();

    if (ulSnapshot.exists) {
      List<String> data = [];
      Map<String, Map<String, dynamic>> metadata = {};
      try {
        // get all documents in sub-collection members
        QuerySnapshot result = await ulReference.collection(subCollectionName).getDocuments();
        // query snapshot is a query result, may contain docs.
        for (int i = 0; i < result.documents.length; i++) {
          DocumentSnapshot uidDoc = result.documents[i];
          String record = uidDoc.documentID;
          data.add(record);
          metadata[record] = uidDoc.data ?? {};
        }
      } catch (e, s) {
        print(s);
      }

      recordList = RecordList.fromDatabase(
        lid: ulReference.documentID,
        data: data,
        metadata: metadata,
      );
    } else {
      print('Tried to get nonexistent record list $lid');
    }

    return recordList;
  }

  Future<void> deleteRecordsList(String lid) async {
    DocumentReference listRef = recordsListCollection.document(lid);

    QuerySnapshot usersSnap = await listRef.collection(subCollectionName).getDocuments();

    for (var userSnap in usersSnap.documents) await userSnap.reference.delete();

    return listRef.delete();
  }

  // Delete all the data !!
  Future<void> deleteAllRecordsLists() async {
    QuerySnapshot snapshot = await recordsListCollection.getDocuments();
    for (DocumentSnapshot docSnap in snapshot.documents) {
      deleteRecordsList(docSnap.documentID);
    }
  }
}
