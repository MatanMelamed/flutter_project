import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teamapp/models/team.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/widgets/chat/message.dart';
import 'package:teamapp/widgets/chat/send_button.dart';
import 'package:teamapp/widgets/general/diamond_image.dart';

class Chat extends StatefulWidget {
  final User user;
  final Team team;

  Chat({Key key, this.user, this.team}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final Firestore _fireStore = Firestore.instance;
  TextEditingController msgController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void _delete() {
    /*
    * Only for debugging purposes !
    * Deletes all 'message' collection from the DB.
    * */
    _fireStore.collection('messages').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) ds.reference.delete();
    });
  }

  Widget _streamBuilder(
      BuildContext cxt, AsyncSnapshot<QuerySnapshot> snapShot) {
    if (!snapShot.hasData)
      return Center(
        child: CircularProgressIndicator(),
      );
    else {
      var myID = widget.user.uid;
      var docs = snapShot.data.documents;

      return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          return Message(
            userID: docs[index].data['userID'],
            message: docs[index].data['message'],
            timestamp: docs[index].data['timestamp'],
            me: myID == docs[index].data['userID'],
          );
        },
        itemCount: docs.length,
        controller: scrollController,
      );
    }
  }

  Future<void> _onSend() async {
    if (msgController.text.length > 0) {
      print("Tean Chat id: ${widget.team.chatId}");
      await _fireStore
          .collection("messages")
          .document(widget.team.chatId)
          .collection("chat")
          .add({
        "message": msgController.text,
        "userID": widget.user.uid,
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      });

      msgController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 600),
      );
    }
  }

  Widget _getUserImage() {
    return DiamondImage(
          imageProvider: NetworkImage(widget.user.remoteImage.url),
        ) ??
        Image.asset("assets/images/default_profile_image.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: 'logo',
          child: Container(
            height: 40.0,
            child: this._getUserImage(),
          ),
        ),
        title: Text(widget.team.name + " Chat"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: this
                    ._fireStore
                    .collection("messages")
                    .document(widget.team.chatId)
                    .collection("chat")
                    .orderBy("timestamp")
                    .snapshots(),
                builder: _streamBuilder,
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: this.msgController,
                      decoration: InputDecoration(
                        hintText: "Enter a message...",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SendButton(
                    onSend: () async {
                      await this._onSend();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
