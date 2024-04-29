import 'package:flutter/material.dart';
import 'package:trendeo/models/sories_view.dart';
import 'package:trendeo/models/stories_items.dart';

class StoriesBar extends StatelessWidget {
  const StoriesBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        children: storiesItems
            .map(
              (stories) => StoriesView(
                storie: stories.storiesImade,
              ),
            )
            .toList(),
      ),
    );
  }
}
