import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trendeo/bloc/social_bloc/social_cubit.dart';
import 'package:trendeo/components/search_bar.dart';
import 'package:trendeo/core/navigator_app.dart';
import 'package:trendeo/core/search_app.dart';
import 'package:trendeo/screens/add_bost_screen.dart';
import 'package:trendeo/themes/theme_animated.dart';
import 'package:trendeo/themes/theme_icon.dart';
import 'package:trendeo/components/post_card.dart';
import 'package:trendeo/core/color_app.dart';
import 'package:trendeo/core/size_app.dart';

import 'package:trendeo/themes/theme_titel.dart';

import '../bloc/social_bloc/social_states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool isSearch = false;

TextEditingController homeSearchController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    SocialCubit.get(context).fetchUserData();
    super.initState();
  }

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
                  text: "Trendeo",
                  size: 40,
                ),
              ),
              ListTile(
                title: SearchAppBar(
                  controller: homeSearchController,
                  onChanged: (value) {
                    if (value != "") {
                      setState(() {
                        isSearch = true;
                      });
                    } else {
                      setState(() {
                        isSearch = false;
                      });
                    }
                  },
                ),
                leading: ThemeAnimated(
                  crossFadeState: isSearch
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: ThemeIcon(
                    iconData: Icons.addchart_outlined,
                    onPressed: () {
                      navigatorApp(context, const AddPostScreen());
                    },
                  ),
                  secondChild: ThemeIcon(
                    iconData: Icons.search_outlined,
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: SearchApp(
                          searchController: homeSearchController.text,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                width: SizeApp.screenWidth! * 1,
                child: BlocConsumer<SocialCubit, SocialStates>(
                  listener: (context, state) {
                    SocialCubit.get(context).isFavorite;
                  },
                  builder: (context, state) {
                    var cubit = SocialCubit.get(context);

                    return StreamBuilder(
                        stream: cubit.postsStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return const Center(
                              child: Text(
                                'No posts to show...',
                                style: TextStyle(fontSize: 30),
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            QuerySnapshot data = snapshot.data as QuerySnapshot;
                            return Column(
                              children: data.docs.map(
                                (value) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: PostCard(
                                      commentCount: value['comment_count'],
                                      postDoc: value.id,
                                      commentController:
                                          cubit.commentController!,
                                      commentStream:
                                          cubit.commentStream(value.id),
                                      deletePost: () {
                                        cubit.deletePost(value.id);

                                        Navigator.pop(context);
                                      },
                                      authorIsUser: value['email'] ==
                                              FirebaseAuth
                                                  .instance.currentUser!.email!
                                          ? true
                                          : false,
                                      onPressed: () {
                                        cubit.likePost(
                                          isFavorite: value['likes']
                                                  .toString()
                                                  .contains(FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .email!)
                                              ? false
                                              : true,
                                          email: FirebaseAuth
                                              .instance.currentUser!.email!,
                                          doc: value.id,
                                        );
                                      },
                                      isFavorite: value['likes']
                                              .toString()
                                              .contains(FirebaseAuth
                                                  .instance.currentUser!.email!)
                                          ? true
                                          : false,
                                      titlePost: value['body'],
                                      likesCount: value['likes'].length,
                                      userName: value['author'],
                                      userImage: value['author_image'],
                                      image: value['image'].toString().length <
                                              5
                                          ? const SizedBox()
                                          : Expanded(
                                              child: GestureDetector(
                                                onDoubleTap: () =>
                                                    cubit.likePost(
                                                  email: FirebaseAuth.instance
                                                      .currentUser!.email!,
                                                  doc: value.id,
                                                  isFavorite:
                                                      cubit.isFavorite == true
                                                          ? cubit.isFavorite =
                                                              false
                                                          : cubit.isFavorite =
                                                              true,
                                                ),
                                                child: Center(
                                                  child: Image.network(
                                                    value['image'],
                                                    fit: BoxFit.fitHeight,
                                                    alignment:
                                                        Alignment.topCenter,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          } else {
                            return const SizedBox(
                              child: Text('No Data'),
                            );
                          }
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
