import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendeo/core/color_app.dart';

class InputUserEditData extends StatelessWidget {
  final String hintText;
  final void Function(String) onChanged;
  final TextEditingController controller;
  final int? maxLines;
  final IconData icon;
  final TextInputType? keyboardType;
  const InputUserEditData({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    this.maxLines = 1,
    required this.icon,
    this.keyboardType = TextInputType.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.only(bottom: 15.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: ColorApp.moodApp ? Colors.white12 : Colors.black12,
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextFormField(
        onChanged: onChanged,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.done,
        controller: controller,
        style: TextStyle(
          color: ColorApp.moodApp
              ? ColorApp.darkTextColor
              : ColorApp.lightTextColor,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          icon: Icon(icon),
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
