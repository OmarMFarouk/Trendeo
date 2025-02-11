import 'package:flutter/material.dart';
import 'package:trendeo/core/color_app.dart';
import 'package:trendeo/themes/theme_description.dart';

class InfoSetteingCard extends StatelessWidget {
  const InfoSetteingCard({
    super.key,
    required this.onPressed,
    required this.iconData,
    required this.text,
  });
  final VoidCallback onPressed;
  final IconData iconData;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Icon(
        iconData,
        color: ColorApp.moodApp
            ? ColorApp.darkDescriptionColor
            : ColorApp.lightDescriptionColor,
      ),
      title: ThemeDescription(text: text),
    );
  }
}
