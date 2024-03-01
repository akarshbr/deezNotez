import 'dart:developer';

import 'package:deeznotes/model/notes_model.dart';
import 'package:deeznotes/view/custom_widget/remove_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';

import '../view/custom_widget/add_category_dialog.dart';

class CategoryController {
  final categoryBox = Hive.box("categories");
  final noteBox = Hive.box("notes");

  void initializeApp() async {
    List defaultCategories = ["Work", "Personal"];
    bool categoryExist = categoryBox.isNotEmpty;
    if (!categoryExist) {
      for (String categoryName in defaultCategories) {
        categoryBox.add(categoryName);
      }
    }
  }

  void addUserCategory(String category) {
    categoryBox.add(category);
  }

  List getAllCategories() {
    return categoryBox.values.toList();
  }

  addCategory(
      {required BuildContext context,
      required TextEditingController categoryController,
      required CategoryController catController,
      required void Function() fetchData}) {
    return showDialog(
      context: context,
      builder: (context) => AddCategoryDialog(
        categoryController: categoryController,
        catController: catController,
        fetchData: fetchData,
      ),
    );
  }

  void removeUserCategory({required int categoryIndex, required Function() fetchData}) {
    noteBox.delete(categoryIndex);
    categoryBox.delete(categoryIndex);
    fetchData();
  }

  removeCategory(
      {required int categoryIndex,
      required String categoryName,
      required BuildContext context,
      required void Function() fetchData}) {
    return showDialog(
        context: context,
        builder: (context) => RemoveCategoryWidget(
            categoryName: categoryName, categoryIndex: categoryIndex, fetchData: fetchData));
  }
}

class NotesController {
  final noteBox = Hive.box("notes");

  void addNote(
      {required GlobalKey<FormState> formKey,
      required String title,
      required String description,
      required String date,
      required int category,
      required TextEditingController titleController,
      required TextEditingController descriptionController,
      required BuildContext context}) {
    if (formKey.currentState!.validate()) {
      List<NotesModel> currentNotes =
          noteBox.containsKey(category) ? noteBox.get(category)!.cast<NotesModel>() : [];
      var note = NotesModel(title: title, description: description, date: date, category: category);
      currentNotes.add(note);
      noteBox.put(category, currentNotes);
      titleController.clear();
      descriptionController.clear();
      Navigator.pop(context);
    }
  }

  void deleteNote(
      {required var key,
      required NotesModel note,
      required void Function() fetchData,
      required int index}) {
    List<NotesModel> list = noteBox.get(key)!.cast<NotesModel>();
    if (index < 0 || index >= list.length) {
      log("Invalid index");
      return;
    }
    list.remove(note);
    noteBox.put(key, list);
    if (list.isEmpty) {
      noteBox.delete(key);
    }
  }

  void editNote(
      {required String title,
      required String description,
      required String date,
      required int category,
      required GlobalKey<FormState> formKey,
      required int indexOfNote,
      required int oldCategory}) {
    List<NotesModel> currentNote = noteBox.get(oldCategory)?.cast<NotesModel>() ?? [];
    NotesModel newNote = NotesModel(
        title: title, description: description, date: date.toString(), category: category);
    currentNote.removeAt(indexOfNote);
    noteBox.put(oldCategory, currentNote);
    if (currentNote.isEmpty) {
      noteBox.delete(oldCategory);
    }
    List<NotesModel> editedNote = noteBox.get(category)?.cast<NotesModel>() ?? [];
    editedNote.add(newNote);
    noteBox.put(category, editedNote);
  }

  void shareNote({required String note}) {
    Share.share(note);
  }
}
