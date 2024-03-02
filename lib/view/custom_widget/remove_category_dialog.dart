import 'package:deeznotes/controller/home_screen_controller.dart';
import 'package:flutter/material.dart';

class RemoveCategoryWidget extends StatelessWidget {
  const RemoveCategoryWidget(
      {super.key,
      required this.categoryName,
      required this.categoryIndex,
      required this.fetchData});

  final String categoryName;
  final int categoryIndex;
  final void Function() fetchData;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Delete : $categoryName")),
      actions: [Center(child: ElevatedButton(onPressed: () {
        CategoryController().removeUserCategory(categoryIndex: categoryIndex, fetchData: fetchData);
        Navigator.pop(context);
      }, child: Text("Delete")))],
    );
  }
}
