import 'package:dubts/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final rtdb = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://dubts-a851d-default-rtdb.firebaseio.com/');
  late DatabaseReference ref = rtdb.ref();

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

  Future<void> deleteLocationData(String deviceID, String busName, String busCode) async {
    print('Deleting location data...');
    String id = deviceID.replaceAll('.', '');
    print('Data to be deleted: $id, $busName, $busCode');
    try {
      DatabaseReference locationRef = await ref
          .child('location')
          .child(busName)
          .child(busCode)
          .child(id);
      await locationRef.remove();
    } on Exception catch (e) {
      print(e);
    }
    print('Deleted location data');
  }

  Future logOut(String deviceID, String busName, String busCode) async {
    try {
      print("in sign out");
      await deleteLocationData(deviceID, busName, busCode);
      return await FirebaseAuth.instance.signOut();
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      return null;
    }
  }


}
