import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trendeo/bloc/user_bloc/user_states.dart';
import 'package:trendeo/core/shared.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());
  static UserCubit get(context) => BlocProvider.of(context);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream? usersStream;
  Stream? postsStream;

  TextEditingController? nameController = TextEditingController();
  TextEditingController? fbController = TextEditingController();
  TextEditingController? igController = TextEditingController();
  TextEditingController? phoneController = TextEditingController();
  TextEditingController? bioController = TextEditingController();
  String imageLink = "";
  bool hasPostImage = false;
  String? profilePicture;
  bool hasProfileImage = false;
  bool isFavorite = false;

  Stream fetchUserData() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .snapshots();
  }

  Future imgFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      final fileName = "${FirebaseAuth.instance.currentUser!.email}.png";
      final destination = 'images/$fileName';

      try {
        print(destination);

        final ref = FirebaseStorage.instance.ref(destination);
        await ref.putFile(file);
        imageLink = await FirebaseStorage.instance
            .ref()
            .child(destination)
            .getDownloadURL();
        hasPostImage = true;
        emit(UserSuccessState());
        return imageLink;
      } catch (e) {
        print('error occured');
        print('error is $e');
      }
    }
  }

  changeProfilePicture() async {
    imgFromGallery().then((value) {
      if (profilePicture != "") {
        _firestore.collection('users').doc(_auth.currentUser!.uid).update({
          "image": imageLink,
        });
        SharedPref.localStorage?.setString('userImage', imageLink);
        imageLink = "";
        hasProfileImage = false;
      }
    });
  }

  saveProfileData() {
    if (nameController!.text != '') {
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({"name": nameController!.text});
    }
    if (fbController!.text != '') {
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({"fb_link": fbController!.text});
    }
    if (igController!.text != '') {
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({"ig_link": igController!.text});
    }
    if (phoneController!.text != '') {
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({"phone": phoneController!.text});
    }
    if (bioController!.text != '') {
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({"bio": bioController!.text});
    }

    nameController!.clear();
    fbController!.clear();
    igController!.clear();
    phoneController!.clear();
    bioController!.clear();
  }
}
