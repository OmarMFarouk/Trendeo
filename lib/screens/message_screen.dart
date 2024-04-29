import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendeo/bloc/social_bloc/social_cubit.dart';
import 'package:trendeo/bloc/social_bloc/social_states.dart';
import 'package:trendeo/components/message_bar.dart';
import 'package:trendeo/components/message_card.dart';
import 'package:trendeo/core/color_app.dart';
import 'package:trendeo/themes/theme_animated.dart';
import 'package:trendeo/themes/theme_icon.dart';
import 'package:trendeo/widgets/inpout_message.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen(
      {super.key,
      required this.receiverEmail,
      required this.receiverId,
      required this.receiverName,
      required this.receiverStatus});
  String receiverEmail;
  String receiverId;
  String receiverName;
  bool? receiverStatus;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  bool isRecording = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
      );
    } else {}
  }

  bool isMessage = false;
  bool showOpshen = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          backgroundColor: ColorApp.moodApp
              ? ColorApp.darkBackgroundColor
              : ColorApp.lightBackgroundColor,
          body: Form(
            key: _formKey,
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: MessageBar(
                          receiverName: widget.receiverName,
                          receiverStatus: widget.receiverStatus,
                        ),
                      ),
                      StreamBuilder(
                        stream: cubit.getMessages(
                            FirebaseAuth.instance.currentUser!.uid,
                            widget.receiverId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          QuerySnapshot messages =
                              snapshot.data as QuerySnapshot;

                          return Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              reverse: true,
                              controller: scrollController,
                              children: messages.docs.map((e) {
                                if (e['type'] == 'text') {
                                  return Align(
                                    alignment: e['senderEmail'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.email
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: MessageCard(
                                        e: e,
                                        isVoice: false,
                                      ),
                                    ),
                                  );
                                }
                                return Align(
                                  alignment: e['senderEmail'] ==
                                          FirebaseAuth
                                              .instance.currentUser!.email
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MessageCard(
                                      e: e,
                                      isVoice: true,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: isMessage
                              ? ThemeIcon(
                                  iconData: Icons.send,
                                  onPressed: () {
                                    cubit.url = '';
                                    cubit.sendMessage(
                                        widget.receiverId, 'text');
                                    scrollDown();
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      isMessage = false;
                                      showOpshen = false;
                                    });
                                  },
                                )
                              : Column(
                                  children: [
                                    ThemeIcon(
                                      iconData: showOpshen
                                          ? Icons.close
                                          : Icons.attach_file_outlined,
                                      onPressed: () {
                                        setState(() {
                                          showOpshen = !showOpshen;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                          title: MyField(
                            hint: 'Message',
                            controller: cubit.msgController!,
                            onChanged: (message) {
                              if (message != "") {
                                setState(() {
                                  isMessage = true;
                                });
                              } else {
                                setState(() {
                                  isMessage = false;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 70.h,
                    left: 18.w,
                    child: ThemeAnimated(
                      crossFadeState: showOpshen
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      secondChild: Column(
                        children: [
                          ThemeIcon(
                            iconData:
                                isRecording == false ? Icons.mic : Icons.stop,
                            onPressed: () {
                              if (isRecording == false) {
                                cubit.startRecord();
                                setState(() {
                                  isRecording = true;
                                });
                              } else {
                                setState(() {
                                  isRecording = false;
                                });
                                cubit.stopRecord();
                                Timer(Duration(seconds: 2), () {
                                  cubit.sendMessage(widget.receiverId, 'voice');
                                });
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ThemeIcon(
                              iconData: Icons.videocam,
                              onPressed: () {},
                            ),
                          ),
                          ThemeIcon(
                            iconData: Icons.photo_camera,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
