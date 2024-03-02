import 'package:deeznotes/controller/home_screen_controller.dart';
import 'package:flutter/material.dart';

class AddCategoryDialog extends StatelessWidget {
  const AddCategoryDialog(
      {super.key,
      required this.categoryController,
      required this.catController,
      required this.fetchData});

  final TextEditingController categoryController;
  final CategoryController catController;
  final void Function() fetchData;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Add Category")),
      content: TextFormField(
        controller: categoryController,
        maxLines: 1,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            labelText: "Category",
            labelStyle: TextStyle(fontSize: 15),
            contentPadding: const EdgeInsets.all(20),
            border: InputBorder.none,
            focusedBorder: InputBorder.none),
      ),
      actions: [Center(child: ElevatedButton(onPressed: () {
        catController.addUserCategory(categoryController.text);
        categoryController.clear();
        Navigator.pop(context);
        fetchData();
      }, child: Text("Add")))],
    );
  }
}
