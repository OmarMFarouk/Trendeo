import 'package:flutter/material.dart';
import 'package:trendeo/components/search_bar.dart';
import 'package:trendeo/core/color_app.dart';
import 'package:trendeo/core/search_app.dart';
import 'package:trendeo/themes/theme_icon.dart';
import 'package:trendeo/themes/theme_titel.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
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
                  text: "Trendeo Search",
                  size: 30,
                ),
              ),
              ListTile(
                leading: ThemeIcon(
                    iconData: Icons.search,
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: SearchApp(
                          searchController: searchController.text,
                        ),
                      );
                    }),
                title: SearchAppBar(
                  controller: searchController,
                  onChanged: (p0) {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
