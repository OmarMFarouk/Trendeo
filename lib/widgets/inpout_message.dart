import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendeo/core/color_app.dart';

class MyField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  final String hint;
  const MyField(
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
      ),
      child: TextFormField(
        onChanged: onChanged,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
        controller: controller,
        style: TextStyle(
          color: ColorApp.moodApp
              ? ColorApp.darkTextColor
              : ColorApp.lightTextColor,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "$hint ...",
          hintStyle: TextStyle(
            fontSize: 17.sp,
            color: ColorApp.moodApp
                ? ColorApp.darkDescriptionColor
                : ColorApp.lightDescriptionColor,
          ),
        ),
      ),
    );
  }
}
