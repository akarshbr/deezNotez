import 'package:deeznotes/controller/home_screen_controller.dart';
import 'package:deeznotes/model/notes_model.dart';
import 'package:deeznotes/view/custom_widget/notes_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var noteBox = Hive.box("notes");
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryTextController = TextEditingController();
  List categories = [];
  int categoryIndex = 0;
  CategoryController categoryController = CategoryController();
  NotesController notesController = NotesController();
  List myKeyList = [];
  bool isEditing = false;

  @override
  void initState() {
    categoryController.initializeApp();
    categories = categoryController.getAllCategories();
    fetchData();
    super.initState();
  }

  void fetchData() {
    myKeyList = noteBox.keys.toList();
    categories = categoryController.getAllCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView.separated(
        itemCount: myKeyList.length,
        itemBuilder: (context, index) {
          List<NotesModel> notesInCategory = noteBox.get(myKeyList[index])!.cast<NotesModel>();
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(categories[myKeyList[index]]),
                Column(
                  children: List.generate(notesInCategory.length, (inIndex) {
                    return NotesWidget(
                      title: notesInCategory[notesInCategory.length - inIndex - 1].title,
                      description:
                          notesInCategory[notesInCategory.length - inIndex - 1].description,
                      date: notesInCategory[notesInCategory.length - inIndex - 1].date,
                      category: categories[myKeyList[index]],
                      onDelete: () {
                        notesController.deleteNote(
                            key: myKeyList[index],
                            note: notesInCategory[notesInCategory.length - inIndex - 1],
                            fetchData: fetchData,
                            index: notesInCategory.length - inIndex - 1);
                        fetchData();
                        setState(() {});
                      },
                      onUpdate: () {
                        titleController.text =
                            notesInCategory[notesInCategory.length - inIndex - 1].title;
                        descriptionController.text =
                            notesInCategory[notesInCategory.length - inIndex - 1].description;
                        categoryIndex =
                            notesInCategory[notesInCategory.length - inIndex - 1].category;
                        isEditing = true;
                        bottomSheet(context,
                            key: myKeyList[index],
                            indexOfEditing: notesInCategory.length - inIndex - 1,
                            currentCategory:
                                notesInCategory[notesInCategory.length - inIndex - 1].category);
                        setState(() {});
                      },
                    );
                  }),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 20);
        },
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () => bottomSheet(context), child: Icon(CupertinoIcons.plus)),
    );
  }

  Future<dynamic> bottomSheet(BuildContext context,
      {var key, int? indexOfEditing, int? currentCategory}) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, insetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: titleController,
                      maxLines: 1,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          isDense: false,
                          contentPadding: const EdgeInsets.all(20),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                    SizedBox(
                      height: 150,
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            hintText: "Description",
                            hintStyle: TextStyle(fontSize: 15),
                            isDense: false,
                            contentPadding: const EdgeInsets.all(20),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Category",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          categories.length + 1,
                          (index) => index == categories.length
                              ? InkWell(
                                  onTap: () {
                                    categoryTextController.clear();
                                    categoryController.addCategory(
                                        context: context,
                                        categoryController: categoryTextController,
                                        catController: categoryController,
                                        fetchData: fetchData);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    child: const Text(
                                      " + Add Category",
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: InkWell(
                                    onTap: () {
                                      categoryIndex = index;
                                      insetState(() {});
                                    },
                                    onLongPress: () {
                                      categoryController.removeCategory(
                                          categoryIndex: index,
                                          categoryName: categories[index].toString(),
                                          context: context,
                                          fetchData: fetchData);
                                      fetchData();
                                      setState(() {});
                                      insetState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        categories[index].toString(),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                titleController.clear();
                                descriptionController.clear();
                                Navigator.pop(context);
                                isEditing = false;
                                setState(() {});
                              },
                              child: const Text("Cancel")),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        SizedBox(
                          width: 80,
                          child: ElevatedButton(
                              onPressed: () {
                                if (isEditing) {
                                  notesController.editNote(
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      date: DateFormat("dd:MM:yyyy")
                                          .format(DateTime.now())
                                          .toString(),
                                      category: categoryIndex,
                                      formKey: _formKey,
                                      indexOfNote: indexOfEditing!,
                                      oldCategory: currentCategory!);
                                  isEditing = false;
                                  titleController.clear();
                                  descriptionController.clear();
                                  fetchData();
                                  categoryIndex = 0;
                                  Navigator.pop(context);
                                } else {
                                  notesController.addNote(
                                      formKey: _formKey,
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      date: DateFormat("dd:MM:yyyy")
                                          .format(DateTime.now())
                                          .toString(),
                                      category: categoryIndex,
                                      titleController: titleController,
                                      descriptionController: descriptionController,
                                      context: context);
                                  fetchData();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text("Notes Added")));
                                  setState(() {});
                                }
                              },
                              child: isEditing ? Text("Edit") : Text("Add")),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
