import 'package:deeznotes/controller/home_screen_controller.dart';
import 'package:flutter/material.dart';

class NotesWidget extends StatelessWidget {
  const NotesWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.category,
      this.onDelete,
      this.onUpdate});

  final String title;
  final String description;
  final String date;
  final String category;
  final void Function()? onDelete;
  final void Function()? onUpdate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: InkWell(
        onTap: () {},
        child: Container(
          color: Colors.blue,
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(title),
                trailing: Wrap(
                  children: [
                    IconButton(onPressed: onUpdate, icon: Icon(Icons.edit)),
                    IconButton(onPressed: onDelete, icon: Icon(Icons.delete))
                  ],
                ),
              ),
              Text(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              ListTile(
                title: Text(date),
                trailing: IconButton(
                    onPressed: () {
                      String shareNote = "$title\n$description";
                      NotesController().shareNote(note: shareNote);
                    },
                    icon: Icon(Icons.share)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
