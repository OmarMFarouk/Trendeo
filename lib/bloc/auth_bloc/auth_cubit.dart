import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendeo/core/shared.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());
  bool? isLogging;
  static AuthCubit get(context) => BlocProvider.of(context);
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  registerUser(BuildContext context) async {
    if (email.text.isEmpty || password.text.isEmpty || name.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) =>
              const AlertDialog(content: Text("Some or all fields are empty")));
    } else {
      try {
        emit(AuthInitial());
        await _auth
            .createUserWithEmailAndPassword(
                email: email.text, password: password.text)
            .then((value) => _firestore
                    .collection('users')
                    .doc(
                      _auth.currentUser!.uid,
                    )
                    .set({
                  'name': name.text,
                  'email': email.text,
                  'fb_link': '',
                  'ig_link': '',
                  'phone': '',
                  'uid': _auth.currentUser!.uid,
                  'date_created': DateTime.now(),
                  'last_access': DateTime.now(),
                  'active': true,
                  'bio': 'empty bio...',
                  'image':
                      'https://firebasestorage.googleapis.com/v0/b/trendeo.appspot.com/o/def.png?alt=media&token=6799b70a-e2c7-4fae-9595-fae0b9e0560c'
                }).then((value) {
                  emit(AuthSuccess());
                  name.clear();
                  email.clear();
                  password.clear();
                }));

        await SharedPref.localStorage?.setString('userImage',
            'https://firebasestorage.googleapis.com/v0/b/trendeo.appspot.com/o/def.png?alt=media&token=6799b70a-e2c7-4fae-9595-fae0b9e0560c');
        await SharedPref.localStorage?.setString('name', name.text);
      } on FirebaseAuthException catch (e) {
        emit(AuthError());
        // showDialog(
        //         context: context,
        //         builder: (context) => AlertDialog(
        //             content:
        //                 Text(e.toString().replaceAll('[firebase_auth/', ''))))
        //     .then((value) => emit(AuthError()));
      }
    }
  }

  loginUser(BuildContext context) async {
    if (email.text.isEmpty || password.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) =>
              const AlertDialog(content: Text("Some or all fields are empty")));
    } else {
      try {
        emit(AuthInitial());
        await _auth
            .signInWithEmailAndPassword(
                email: email.text, password: password.text)
            .then((value) => _firestore
                .collection('users')
                .doc(
                  _auth.currentUser!.uid,
                )
                .update({'active': true}))
            .then((value) => emit(AuthSuccess()));

        Future.delayed(Duration(seconds: 5), () {
          name.clear();
          email.clear();
          password.clear();
        });
      } on FirebaseAuthException catch (e) {
        emit(AuthError());
        // showDialog(
        //     // ignore: use_build_context_synchronously
        //     context: context,
        //     builder: (context) => AlertDialog(
        //         content: Text(e.toString().replaceAll('[firebase_auth/', ''))));
      }
    }
  }

  logoutUser(BuildContext context) {
    try {
      _firestore
          .collection('users')
          .doc(
            _auth.currentUser!.uid,
          )
          .update({'last_access': DateTime.now(), 'active': false}).then(
              (value) => _auth.signOut());
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              content: Text(e.toString().replaceAll('[firebase_auth/', ''))));
    }
  }
}
