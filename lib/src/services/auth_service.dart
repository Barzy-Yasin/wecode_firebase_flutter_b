import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  // used in register screen
  Future<UserCredential> registerWithEmailAndPassword(
      String emailFromTheBody, String passwordFromTheBody) async {
    // ignore: no_leading_underscores_for_local_identifiers
    UserCredential _userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailFromTheBody, password: passwordFromTheBody);

    debugPrint("debug Print from method; ${_userCredential.user!.email}");
    return _userCredential;
    //  handle the errors perfectly:
    //try {
    //   final credential =
    //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: emailAddress,
    //     password: password,
    //   );
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     print('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     print('The account already exists for that email.');
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }
 
  Future<UserCredential> loginWithUserAndPassword(
      {required String email, required String password}) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }
}
