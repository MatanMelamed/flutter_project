import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamapp/models/user.dart';
import 'package:teamapp/services/firestore/userDataManager.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // singleton
  static final AuthService _authService = AuthService._internal();
  factory AuthService() => _authService;

  // updates
  static StreamController<User> _streamController;
  static Stream<User> userStateChanges;

  // management
  static bool isInCreationMode = false;
  static String futureUid = '';

  AuthService._internal(){
    _streamController = StreamController<User>();
    userStateChanges = _streamController.stream.asBroadcastStream();
    _firebaseAuth.onAuthStateChanged.listen((data) async {
      if (data == null) {
        // user logged out
        _notifyOnUserLogout();
      } else if (!isInCreationMode) {
        // user logged in
        _notifyOnUserLogin(data.uid);
      } else if (isInCreationMode) {
        // user automatic logged in after creation
        futureUid = data.uid;
      }
    });
  }

  _notifyOnUserLogout() async {
    _streamController.add(null);
  }

  _notifyOnUserLogin(String uid) async {
    //User user = User.fromWithinApp(firstName: "Try1", lastName: "try2", gender: 'male', birthday: DateTime(0,0));
    User user = await UserDataManager.getUser(uid);
    _streamController.add(user);
  }

  void dispose() {
    _streamController.close();
  }

  void startCreationMode() {
    print('authenticaton service is on create mode now.');
    isInCreationMode = true;
  }

  void endCreationMode() async{
    print('authenticaton service is off create mode now.');
    isInCreationMode = false;
    if (futureUid.isNotEmpty) {
      await _notifyOnUserLogin(futureUid);
    }
    futureUid = '';
  }

  /// auth change user stream
  /// Firebase auth sends stream of updates when user signs in or out.
  /// These updates will be handle here.
  Stream<User> get userStream {
    return userStateChanges;
  }

  // sign returns the newly created firebase user
  Future<FirebaseUser> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register returns the newly created firebase user
  Future<FirebaseUser> registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
