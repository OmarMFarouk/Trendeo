import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendeo/themes/theme_description.dart';
import 'package:trendeo/themes/theme_icon.dart';
import 'package:trendeo/themes/theme_titel.dart';

class MessageBar extends StatelessWidget {
  const MessageBar({
    super.key,
    required this.receiverName,
    required this.receiverStatus,
  });

  final String receiverName;
  final bool? receiverStatus;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ThemeIcon(
        iconData: Icons.arrow_back,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: ThemeTitel(
        text: receiverName,
        size: 20,
      ),
      subtitle: ThemeDescription(
        text: receiverStatus == true ? "Online" : "Offline",
      ),
      trailing: Container(
        width: 15.w,
        height: 15.h,
        decoration: BoxDecoration(
          color: receiverStatus == true
              ? const Color(0xFF57F287)
              : const Color(0xFFC1C1BD),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
