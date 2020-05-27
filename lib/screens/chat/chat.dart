import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  static const String id = "CHAT";
  final FirebaseUser user;

  Chat({Key key, this.user}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _fireStore = Firestore.instance;
  TextEditingController msgController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void _delete(bool x) {
    if (x)
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
    List<DocumentSnapshot> docs = snapShot.data.documents;

    List<Widget> messages = docs
        .map(
          (doc) => Message(
            from: doc.data['from'],
            message: doc.data['message'],
            me: widget.user.email == doc.data['from'],
            timeStamp: doc.data['timestamp'],
          ),
        )
        .toList();

    // Only for help and Debug !
    this._delete(false);

    return ListView(
      controller: scrollController,
      children: messages,
    );
  }

  Future<void> _onSend() async {
    if (msgController.text.length > 0) {
      await _fireStore.collection("messages").add({
        "message": msgController.text,
        "from": widget.user.email,
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      });

      msgController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Hero(
          tag: 'logo',
          child: Container(
            height: 40.0,
            child: Image.asset("assets/images/default_profile_image.png"),
          ),
        ),
        title: Text("Tensor Chat"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.of(context).popUntil((r) => r.isFirst);
            },
          )
        ],
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
                    .orderBy('timestamp')
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
                    text: "Send",
                    onSend: this._onSend,
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

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback onSend;

  SendButton({Key key, this.text, this.onSend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: FlatButton(
        color: Colors.blueGrey,
        onPressed: this.onSend,
        child: Text(this.text),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String message;
  final String timeStamp;
  final bool me;

  Message({this.from, this.message, this.me, this.timeStamp});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
            this.me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(from),
          Material(
            color: this.me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(this.message),
            ),
          ),
        ],
      ),
    );
  }
}
