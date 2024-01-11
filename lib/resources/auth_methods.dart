import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String username,
    required String password,
    required String phone,
    required String bio,
    // required Uint8List file,
  }) async {
    String res = "Some error occured...";
    try {
      // validation
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty ||
          phone.isNotEmpty ||
          bio.isNotEmpty) {
        // signin
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // save in users collection
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'username': username,
          'uid': credential.user!.uid,
          'email': email,
          'phone': phone,
          'bio': bio,
          'followers': [],
          'following': [],
        });

        // method 2
        // await _firestore.collection('users').add({
        //   'username': username,
        //   'uid': credential.user!.uid,
        //   'email': email,
        //   'phone': phone,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
