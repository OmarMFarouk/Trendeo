import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendeo/bloc/social_bloc/social_cubit.dart';
import 'package:trendeo/bloc/social_bloc/social_states.dart';
import 'package:trendeo/core/color_app.dart';
import 'package:trendeo/core/navigator_app.dart';
import 'package:trendeo/core/size_app.dart';
import 'package:trendeo/models/chat_card_viow.dart';
import 'package:trendeo/screens/message_screen.dart';
import 'package:trendeo/themes/theme_titel.dart';

class GlobalChatScreen extends StatelessWidget {
  const GlobalChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorApp.moodApp
            ? ColorApp.darkBackgroundColor
            : ColorApp.lightBackgroundColor,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.all(20),
                child: ThemeTitel(
                  text: "Trendeo Chat",
                  size: 30,
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Color(0xFF0EA882))),
                child: ChatCardViow(
                  unread: false,
                  subtitle: '',
                  image:
                      'https://firebasestorage.googleapis.com/v0/b/trendeo.appspot.com/o/openai.png?alt=media&token=713e3290-7a06-49e5-954b-80317fc9ee10',
                  onTap: () {},
                  title: "Trendeo AI Chat",
                  count: 0,
                ),
              ),
              SizedBox(
                  width: SizeApp.screenWidth! * 1,
                  child: BlocConsumer<SocialCubit, SocialStates>(
                      listener: (context, state) {
                    SocialCubit.get(context).isFavorite;
                    SocialCubit.get(context).unReadCount;
                  }, builder: (context, state) {
                    var cubit = SocialCubit.get(context);
                    return StreamBuilder(
                        stream: cubit.usersStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            QuerySnapshot data = snapshot.data as QuerySnapshot;

                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: data.docs.map((value) {
                                  {
                                    return StreamBuilder(
                                        stream: cubit.getLastMessage(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            value.id),
                                        builder: (context, ss) {
                                          if (ss.hasData &&
                                              value['email'] !=
                                                  FirebaseAuth.instance
                                                      .currentUser!.email!) {
                                            QuerySnapshot messages =
                                                ss.data as QuerySnapshot;
                                            if (ss.connectionState ==
                                                ConnectionState.active) {
                                              cubit.getUnreadCount(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  value.id);
                                            }
                                            return Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: ChatCardViow(
                                                count: cubit.unReadCount,
                                                unread: messages.docs
                                                            .map((e) =>
                                                                e['unread'])
                                                            .toString()
                                                            .contains('true') &&
                                                        messages.docs
                                                            .map((e) =>
                                                                e['receiverId'])
                                                            .toString()
                                                            .contains(
                                                                '${FirebaseAuth.instance.currentUser!.uid}')
                                                    ? true
                                                    : false,
                                                subtitle: messages.docs
                                                    .map((e) => e['text'])
                                                    .toString()
                                                    .replaceAll('(', '')
                                                    .replaceAll(')', ''),
                                                image: value['image'],
                                                onTap: () {
                                                  messages.docs
                                                          .map((e) =>
                                                              e['receiverId'])
                                                          .contains(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                      ? cubit.setUnread(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          value.id)
                                                      : null;
                                                  navigatorApp(
                                                      context,
                                                      MessageScreen(
                                                        receiverStatus:
                                                            value['active'],
                                                        receiverName:
                                                            value['name'],
                                                        receiverEmail:
                                                            value['email'],
                                                        receiverId: value.id,
                                                      ));
                                                },
                                                title: value['name'],
                                              ),
                                            );
                                          }
                                          return Center();
                                        });
                                  }
                                }).toList());
                          } else
                            return Center();
                        });
                  }))
            ]))));
  }
}
