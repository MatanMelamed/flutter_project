import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamapp/models/user.dart';

class AuthService {
  final FirebaseAuth _firebase_auth = FirebaseAuth.instance;

  User _convertFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  /***
   * auth change user stream
   * Firebase auth sends stream of updates when user signs in or out.
   * These updates will be handle here.
   */

  Stream<User> get user_stream {
    return _firebase_auth.onAuthStateChanged.map(_convertFirebaseUser);
  }

  // sign in with email & password

  // register

  // sign out
  Future signOut() async {
    try {
      return await _firebase_auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
