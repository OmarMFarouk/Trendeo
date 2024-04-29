import 'package:path/path.dart' as p;

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:trendeo/bloc/social_bloc/social_states.dart';
import 'package:trendeo/core/shared.dart';
import 'package:uuid/uuid.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());
  static SocialCubit get(context) => BlocProvider.of(context);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream? usersStream;
  Stream? postsStream;
  Stream? userData;
  TextEditingController? controller = TextEditingController();
  TextEditingController? msgController = TextEditingController();
  TextEditingController? commentController = TextEditingController();
  String imageLink = "";
  bool hasPostImage = false;
  String? profilePicture;
  bool hasProfileImage = false;
  bool isFavorite = false;
  int unReadCount = 0;
  final record = AudioRecorder();
  String path = '';
  String url = '';

  startRecord() async {
    final location = await getApplicationDocumentsDirectory();
    String name = Uuid().v1();
    if (await record.hasPermission()) {
      await record.start(const RecordConfig(),
          path: '${location.path}$name.m4a');
    }
    print('start record');
  }

  stopRecord() async {
    String? finalPath = await record.stop();
    path = finalPath!;
    print('stop record');
    await uploadRecord();
  }

  uploadRecord() async {
    String name = p.basename(path);
    final ref = FirebaseStorage.instance.ref('voice/$name');
    await ref.putFile(File(path));
    String voiceUrl = await ref.getDownloadURL();
    url = voiceUrl;
    print('uploaded $url');
    emit(UploadComplete());
  }

  fetchPosts() {
    postsStream = _firestore
        .collection('posts')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  fetchUsers() {
    usersStream = _firestore.collection('users').snapshots();
  }

  fetchUserData() {
    FirebaseAuth.instance.currentUser != null
        ? userData = _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
        : null;
  }

  // likeChecker({required bool isFavorite, required doc}) {
  //   !isFavorite
  //       ? likePost(
  //           operation: "like",
  //           email: FirebaseAuth.instance.currentUser!.email,
  //           doc: doc)
  //       : likePost(
  //           operation: "unlike",
  //           email: FirebaseAuth.instance.currentUser!.email,
  //           doc: doc);
  // }

  likePost({required email, required bool isFavorite, required doc}) async {
    if (isFavorite == true) {
      return await _firestore.collection('posts').doc(doc).update({
        "likes": FieldValue.arrayUnion(['$email'])
      });
    } else {
      return await _firestore.collection('posts').doc(doc).update({
        "likes": FieldValue.arrayRemove(['$email'])
      });
    }
  }

  Future imgFromGallery() async {
    emit(SocialInitialState());
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      pickedFile.name;
      final fileName =
          "${FirebaseAuth.instance.currentUser!.email}${pickedFile.name}.png";
      final destination = 'posts/$fileName';

      try {
        print(destination);

        final ref = FirebaseStorage.instance.ref(destination);
        await ref.putFile(file);
        imageLink = await FirebaseStorage.instance
            .ref()
            .child(destination)
            .getDownloadURL();
        hasPostImage = true;
        emit(SocialSuccessState());
        return imageLink;
      } catch (e) {
        print('error occured');
        print('error is $e');
      }
    }
  }

  addPost(String author, image) async {
    if (imageLink != "" && controller!.text.isNotEmpty) {
      await _firestore.collection('posts').add({
        "author": author,
        "image": imageLink,
        "email": FirebaseAuth.instance.currentUser!.email,
        "likes": [],
        "body": controller!.text,
        "comment_count": 0,
        "author_image": image,
        "created_at": "${DateTime.now()}",
      });
      controller!.clear();
      hasPostImage = false;
      imageLink = "";
    }
  }

  deletePost(doc) async {
    return await _firestore.collection('posts').doc(doc).delete();
  }

  Future imgFromGallery2() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      final fileName = "${FirebaseAuth.instance.currentUser!.email}.png";
      final destination = 'avatar/$fileName';

      try {
        print(destination);

        final ref = FirebaseStorage.instance.ref(destination);
        await ref.putFile(file);
        profilePicture = await FirebaseStorage.instance
            .ref()
            .child(destination)
            .getDownloadURL();
        hasProfileImage = true;
        emit(SocialSuccessState());
        SharedPref.localStorage?.setString('image', '$profilePicture');
        return profilePicture;
      } catch (e) {
        print('error occured');
        print('error is $e');
      }
    }
  }

  Future<void> sendMessage(String receiverId, type) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'type': type,
      'senderId': currentUserId,
      'senderEmail': currentUserEmail,
      'receiverId': receiverId,
      'text': msgController!.text,
      'timeStamp': timestamp,
      'unread': true,
      'voiceUrl': url
    });
    emit(SocialSuccessState());
    msgController!.clear();
  }

  Stream<QuerySnapshot> getMessages(String userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getLastMessage(String userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timeStamp', descending: true)
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot> getChats() {
    return _firestore
        .collection('chat_rooms')
        .orderBy('date')
        .where('users', arrayContains: _auth.currentUser!.email)
        .snapshots();
  }

  setUnread(String userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .get()
        .then((value) => value.docs.forEach((element) {
              _firestore
                  .collection('chat_rooms')
                  .doc(chatRoomId)
                  .collection('messages')
                  .doc(element.id)
                  .update({'unread': false});
            }));
  }

  getUnreadCount(String userId, otherUserId) async {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    var query = _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('unread', isEqualTo: true)
        .count()
        .get(source: AggregateSource.server);
    AggregateQuerySnapshot aggregateQuerySnapshot = await query;
    return unReadCount = aggregateQuerySnapshot.count!;
  }

  Stream commentStream(postDoc) {
    return _firestore
        .collection('posts')
        .doc(postDoc)
        .collection('comments')
        .orderBy('date', descending: false)
        .snapshots();
  }

  addComment(String postDoc, user, image) {
    _firestore
        .collection('posts')
        .doc(postDoc)
        .update({'comment_count': FieldValue.increment(1)});
    return _firestore
        .collection('posts')
        .doc(postDoc)
        .collection('comments')
        .add({
      "user": user,
      "likes": [],
      "email": _auth.currentUser!.email,
      "text": commentController!.text,
      "image": image,
      "date": "${DateTime.now()}",
    });
  }

  deleteComment(String postDoc, commentDoc) {
    _firestore
        .collection('posts')
        .doc(postDoc)
        .update({'comment_count': FieldValue.increment(-1)});
    return _firestore
        .collection('posts')
        .doc(postDoc)
        .collection('comments')
        .doc(commentDoc)
        .delete();
  }
}
