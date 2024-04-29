import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendeo/core/color_app.dart';

class StoriesView extends StatelessWidget {
  const StoriesView({
    super.key,
    required this.storie,
  });
  final String storie;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 90.w,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorApp.moodApp
            ? ColorApp.darkBackgroundColor
            : ColorApp.lightBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: ColorApp.moodApp ? Colors.white12 : Colors.black12,
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
        image: DecorationImage(
          image: AssetImage(storie),
          alignment: Alignment.center,
          fit: BoxFit.fill,
        ),
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
        ),
        onPressed: () {},
      ),
    );
  }
}
