import 'package:deeznotes/utils/constants.dart';
import 'package:flutter/material.dart';

class NotesOpenedScreen extends StatelessWidget {
  const NotesOpenedScreen(
      {super.key, required this.category, required this.title, required this.description});

  final String category;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.notesWidgetColor,
      appBar: AppBar(
        title: Text(category,
            style: const TextStyle(
                fontSize: Constants.appBarTitleFontSize,
                fontWeight: Constants.appBarTitleFontWeight)),
        elevation: 0,
        surfaceTintColor: Constants.notesWidgetColor,
        backgroundColor: Constants.notesWidgetColor,
      ),
      body: Column(
        children: [Text(title), Text(description)],
      ),
    );
  }
}
