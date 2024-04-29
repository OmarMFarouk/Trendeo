import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendeo/bloc/social_bloc/social_cubit.dart';
import 'package:trendeo/bloc/social_bloc/social_states.dart';
import 'package:trendeo/core/color_app.dart';
import 'package:trendeo/core/size_app.dart';
import 'package:trendeo/themes/theme_description.dart';
import 'package:trendeo/themes/theme_icon.dart';
import 'package:trendeo/themes/theme_titel.dart';
import 'package:trendeo/widgets/comment_button.dart';
import 'package:trendeo/widgets/favorite_button.dart';
import 'package:trendeo/widgets/inpout_message.dart';

bool showVanBar = true;

class PostCard extends StatefulWidget {
  const PostCard(
      {super.key,
      required this.titlePost,
      required this.isFavorite,
      required this.userName,
      required this.onPressed,
      required this.postDoc,
      required this.userImage,
      required this.image,
      required this.authorIsUser,
      required this.deletePost,
      required this.commentController,
      required this.commentStream,
      required this.commentCount,
      required this.likesCount});
  final String titlePost;
  final String postDoc;
  final Widget image;
  final VoidCallback onPressed;
  final VoidCallback deletePost;
  final bool isFavorite;
  final String userName;
  final String userImage;
  final int likesCount;
  final bool authorIsUser;
  final Stream commentStream;
  final int commentCount;
  final TextEditingController commentController;
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.sp),
      width: SizeApp.screenWidth! * 1,
      height: SizeApp.screenHeight! * 0.5 + 100,
      decoration: BoxDecoration(
        color: ColorApp.moodApp
            ? ColorApp.darkBackgroundColor
            : ColorApp.lightBackgroundColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: ColorApp.moodApp ? Colors.white12 : Colors.black12,
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: ThemeTitel(
                textAlign: TextAlign.start,
                text: widget.userName,
                size: 18,
              ),
              trailing: widget.authorIsUser
                  ? PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: widget.deletePost,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Delete"),
                                SizedBox(width: 10),
                                Icon(Icons.delete),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : null,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.userImage),
                backgroundColor: ColorApp.moodApp
                    ? ColorApp.darkDelicateColor
                    : ColorApp.lightDelicateColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ThemeDescription(text: widget.titlePost),
          ),
          widget.image,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FavoriteButton(
                  onPressed: widget.onPressed,
                  isFavorite: widget.isFavorite,
                  count: widget.likesCount,
                ),
                SizedBox(width: 20.w),
                CommentButton(
                  onPressed: () {
                    setState(() {
                      showVanBar = false;
                    });
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BlocConsumer<SocialCubit, SocialStates>(
                          listener: (context, state) {},
                          builder: (context, state) => Dialog(
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  height: SizeApp.screenHeight!,
                                  width: SizeApp.screenWidth!,
                                  decoration: BoxDecoration(
                                    color: ColorApp.moodApp
                                        ? ColorApp.darkBackgroundColor
                                        : ColorApp.lightBackgroundColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.r),
                                      topRight: Radius.circular(20.r),
                                    ),
                                  ),
                                  child: Expanded(
                                    child: StreamBuilder(
                                        stream: widget.commentStream,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          if (snapshot.hasData) {
                                            QuerySnapshot data =
                                                snapshot.data as QuerySnapshot;
                                            return ListView.builder(
                                              itemCount: data.docs.length,
                                              itemBuilder: (context, index) =>
                                                  ListTile(
                                                trailing: data.docs[index]
                                                            ['email'] ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.email
                                                    ? IconButton(
                                                        onPressed: () {
                                                          SocialCubit.get(
                                                                  context)
                                                              .deleteComment(
                                                                  widget
                                                                      .postDoc,
                                                                  data
                                                                      .docs[
                                                                          index]
                                                                      .id);
                                                        },
                                                        icon:
                                                            Icon(Icons.delete))
                                                    : null,
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      data.docs[index]
                                                          ['image']),
                                                ),
                                                title: ThemeTitel(
                                                  textAlign: TextAlign.start,
                                                  size: 14,
                                                  text: data.docs[index]
                                                      ['user'],
                                                ),
                                                subtitle: Text(
                                                    data.docs[index]['text']),
                                              ),
                                            );
                                          }
                                          return const Center();
                                        }),
                                  ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(1.05, -1.05),
                                  child: ThemeIcon(
                                    iconData: Icons.close,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                StreamBuilder(
                                    stream: SocialCubit.get(context).userData,
                                    builder: (context, dataSnapshot) {
                                      if (dataSnapshot.hasData) {
                                        DocumentSnapshot data = dataSnapshot
                                            .data as DocumentSnapshot;
                                        return Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              leading: ThemeIcon(
                                                iconData: Icons.send,
                                                onPressed: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  SocialCubit.get(context)
                                                      .addComment(
                                                          widget.postDoc,
                                                          data['name'],
                                                          data['image']);
                                                  widget.commentController
                                                      .clear();
                                                },
                                              ),
                                              title: MyField(
                                                hint: 'Comment',
                                                controller:
                                                    widget.commentController,
                                                onChanged: (message) {},
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    }),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  isComment: true,
                  count: widget.commentCount,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
