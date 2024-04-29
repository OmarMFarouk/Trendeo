import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendeo/core/color_app.dart';

class UserImageCard extends StatelessWidget {
  const UserImageCard({
    required this.userImage,
    super.key,
  });
  final String userImage;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 150.w,
      decoration: BoxDecoration(
        // Src user photo
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(userImage),
        ),
        color: ColorApp.moodApp
            ? ColorApp.darkBackgroundColor
            : ColorApp.lightBackgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorApp.moodApp ? Colors.white12 : Colors.black12,
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}
