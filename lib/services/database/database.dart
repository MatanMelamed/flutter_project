
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamapp/models/user.dart';

class DatabaseService {

  // every user in firebase have a uid when he sign up,
  // so we use this to call the document of the user.
  // TODO - auth - FirebaseUser -> take the uid.
  final String userId;
  DatabaseService({this.userId});

  // if this collection don't exist firestore will create new empty one
  final CollectionReference usersCollection = Firestore.instance.collection('users');

  // TODO - need to add more things
  Future signUpUserData(String fullname, DateTime birthday, String gender) async{
    return usersCollection.document(userId).setData({
      'uid': userId,
      'name': fullname,
      'birthday': birthday,
      'gender': gender
    });
  }

  // add the friend document ref to the friend list.
  Future addNewFriend(String friendId) async{
    DocumentReference friendRef = usersCollection.document(friendId);
    usersCollection.document(userId).updateData({'friends': FieldValue.arrayUnion([friendRef])});
  }


  // snapshot automatic update when the document update
  Stream<List<User>> get userFriends{
    return usersCollection.document(this.userId).collection('friends').snapshots()
        .map(_usersListFromSnapshot);
  }

  // get a User List from the users Snapshot
  List<User> _usersListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return User(
        uid: doc.data['uid']
      );
    }).toList();
  }

  //need to add - get notifications stream

}




