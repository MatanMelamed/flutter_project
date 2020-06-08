import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDataManager {
  static final CollectionReference messagesCollection =
      Firestore.instance.collection("messages");

  static Future<void> deleteChat(String chatId) async {
    DocumentReference messagesRef = messagesCollection.document(chatId);

    QuerySnapshot messagesSnap =
        await messagesRef.collection("chat").getDocuments();

    for (var messageSnap in messagesSnap.documents)
      await messageSnap.reference.delete();

    return messagesRef.delete();
  }
}
