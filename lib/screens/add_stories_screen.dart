import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendeo/core/color_app.dart';
import 'package:trendeo/core/size_app.dart';
import 'package:trendeo/themes/theme_button.dart';
import 'package:trendeo/themes/theme_icon.dart';
import 'package:trendeo/themes/theme_titel.dart';

class AddStoriesScreen extends StatelessWidget {
  const AddStoriesScreen({super.key});

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
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: ThemeIcon(
                  iconData: Icons.arrow_back,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: ThemeTitel(
                  text: "Make a stories!",
                  size: 35,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.sp),
                  width: SizeApp.screenWidth! * 1,
                  height: SizeApp.screenHeight! * 0.5 + 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorApp.moodApp
                          ? ColorApp.darkPrimaryColor
                          : ColorApp.lightPrimaryColor,
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_outlined,
                      size: 50.w,
                      color: ColorApp.moodApp
                          ? ColorApp.darkPrimaryColor
                          : ColorApp.lightPrimaryColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ThemeButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icons.addchart_outlined,
                  text: "Add to stories",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
