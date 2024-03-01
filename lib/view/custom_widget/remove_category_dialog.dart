import 'package:flutter/material.dart';

class RemoveCategoryWidget extends StatelessWidget {
  RemoveCategoryWidget(
      {super.key,
      required this.categoryName,
      required this.categoryIndex,
      required this.fetchData});

  String categoryName;
  int categoryIndex;
  final void Function() fetchData;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Delete : $categoryName")),
      actions: [Center(child: ElevatedButton(onPressed: () {}, child: Text("Delete")))],
    );
  }
}
