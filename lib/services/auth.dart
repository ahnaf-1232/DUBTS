import 'package:dubts/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CustomUser? _userFromFirebaseUser(User user) {
    return user != null ? CustomUser(user.uid) : null;
  }

  Stream<CustomUser?>? get user {
    try {
      return _auth
          .authStateChanges()
          .map((User? user) => user != null ? _userFromFirebaseUser(user) : null);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }


  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      print("User:  $user");
      return _userFromFirebaseUser(user!);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }


  Future signInWithMail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      print("User:  $user");
      return user;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      print("User:  $user");
      return _userFromFirebaseUser(user!);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future logOut() async {
    try {
      print("in sign out");
      return await FirebaseAuth.instance.signOut();
    } catch (error) {
      if (kDebugMode) {
        print('ken hoitese egulaaaaaaaaaaaaaaaaaaaaaaaaa');
        print(error.toString());
      }
      return null;
    }
  }


}
