import 'package:flutter/material.dart';
import 'package:trendeo/core/color_app.dart';
import 'package:trendeo/themes/theme_titel.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({
    super.key,
    required this.onPressed,
    required this.isComment,
    required this.count,
  });

  final VoidCallback onPressed;
  final bool isComment;
  final int count;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorApp.moodApp
            ? ColorApp.darkBackgroundColor
            : ColorApp.lightBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
        ),
      ),
      icon: Icon(
        isComment ? Icons.comment : Icons.comment_outlined,
        color: ColorApp.moodApp
            ? ColorApp.darkAuxiliaryColor
            : ColorApp.lightAuxiliaryColor,
      ),
      label: ThemeTitel(text: "$count", size: 15),
    );
  }
}
