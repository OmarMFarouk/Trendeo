import 'package:flutter/material.dart';
import 'package:trendeo/core/color_app.dart';
import 'package:trendeo/themes/theme_titel.dart';

class HistoryCardInfo extends StatelessWidget {
  final String userName;
  const HistoryCardInfo({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: ColorApp.moodApp
            ? ColorApp.darkPrimaryColor
            : ColorApp.lightPrimaryColor,
      ),
      title: ThemeTitel(
        text: userName,
        size: 20,
      ),
    );
  }
}
