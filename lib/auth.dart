import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOutUser();
}

class Auth implements BaseAuth {
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.toString().trim(), password: password))
        .user;
    print('Signed in: ${user.uid}');
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    User user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password))
        .user;
    return user.uid;
  }

  Future<String> currentUser() async {
    User user = FirebaseAuth.instance.currentUser;
    return user.uid;
  }

  Future<void> signOutUser() async {
    return FirebaseAuth.instance.signOut();
  }
}
