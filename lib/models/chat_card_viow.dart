import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendeo/core/color_app.dart';
import 'package:trendeo/themes/theme_description.dart';
import 'package:trendeo/themes/theme_titel.dart';

class ChatCardViow extends StatelessWidget {
  const ChatCardViow(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.image,
      required this.onTap,
      required this.count,
      required this.unread});
  final String title;
  final bool unread;
  final String subtitle;
  final String image;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: ThemeTitel(
        text: title,
        size: 15,
      ),
      trailing: unread == true
          ? Container(
              width: 25.w,
              height: 25.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorApp.moodApp
                    ? ColorApp.darkPrimaryColor
                    : ColorApp.lightPrimaryColor,
              ),
              child: Center(
                  child: Text(
                "$count",
                style: TextStyle(
                  color: ColorApp.moodApp
                      ? ColorApp.darkBackgroundColor
                      : ColorApp.lightBackgroundColor,
                  // fontSize: 15.sp,
                ),
              )))
          : null,
      subtitle: ThemeDescription(text: subtitle),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(image),
      ),
    );
  }
}
