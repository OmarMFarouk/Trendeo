import 'package:flutter/cupertino.dart';

class SearchAppBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  const SearchAppBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: controller,
      onChanged: onChanged,
    );
  }
}
