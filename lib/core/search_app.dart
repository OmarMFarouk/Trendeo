import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trendeo/core/color_app.dart';

class SearchApp extends SearchDelegate {
  final String searchController;

  SearchApp(
      {super.searchFieldLabel,
      super.searchFieldStyle,
      super.searchFieldDecorationTheme,
      super.keyboardType,
      super.textInputAction,
      required this.searchController});
  @override
  set query(String value) {
    value = searchController;
    super.query = value;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = "",
        icon: Icon(
          Icons.close,
          size: 20.sp,
          color: ColorApp.moodApp
              ? ColorApp.darkDescriptionColor
              : ColorApp.lightDescriptionColor,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(
        Icons.arrow_back_ios,
        size: 20.sp,
        color: ColorApp.moodApp
            ? ColorApp.darkDescriptionColor
            : ColorApp.lightDescriptionColor,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: const CircleAvatar(),
      title: const Text("data"),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: const CircleAvatar(),
      title: const Text("Content"),
    );
  }
}
