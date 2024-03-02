import 'package:deeznotes/controller/home_screen_controller.dart';
import 'package:deeznotes/utils/constants.dart';
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
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Container(
        height: size.height * .2,
        width: size.width * .9,
        margin: EdgeInsets.only(bottom: size.height * 0.01),
        decoration: BoxDecoration(
            color: Constants.notesWidgetColor, borderRadius: Constants.notesWidgetBorderRadius),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: size.width * .05),
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: Constants.titleFontSize,
                          fontWeight: Constants.titleFontWeight)),
                ),
                Wrap(
                  children: [
                    IconButton(
                        onPressed: onUpdate,
                        icon: const Icon(Icons.edit, color: Constants.editNotesIconColor)),
                    IconButton(
                        onPressed: onDelete,
                        icon: Icon(Icons.delete, color: Constants.deleteNotesIconColor))
                  ],
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: size.width * .05),
              child: Text(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: Constants.descriptionFontSize),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: size.width * .05),
                  child: Text(date),
                ),
                IconButton(
                    onPressed: () {
                      String shareNote = "$title\n$description";
                      NotesController().shareNote(note: shareNote);
                    },
                    icon: const Icon(Icons.share, color: Constants.shareNotesIconColor))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
