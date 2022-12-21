import 'package:cached_network_image/cached_network_image.dart';
import 'package:notester/model/model.dart';
import 'package:notester/services/cloud/cloud_note.dart';
import 'package:notester/services/fcm_services.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

typedef NoteCallback = void Function(CloudNote note);
typedef ImageCallback = void Function(String imageUrl);
typedef FileCallBack = void Function(Args args);

class NotesListView extends StatefulWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback? onTap;
  final NoteCallback? onLongPress;
  final ImageCallback? onImageTap;
  final FileCallBack? onFileTap;
  const NotesListView({Key? key, required this.notes, this.onTap, this.onLongPress, this.onImageTap, this.onFileTap})
      : super(key: key);

  @override
  State<NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  bool _notSent = false;
  sharedPref() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    _notSent = sharedPreferences.getBool("notificationSent") ?? false;
    return _notSent;
  }

  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late final FcmServices fcmServices = FcmServices();
    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, childAspectRatio: 1 / 1.3, crossAxisSpacing: 8, mainAxisSpacing: 8),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final note = widget.notes.elementAt(index);
            Future.delayed(const Duration(milliseconds: 500), () {
              if (note.reminder != null) {
                if (note.reminder != "") {
                  if (!_notSent) {
                    if (DateTime.now().isAfter(DateTime.parse(note.reminder!).subtract(const Duration(minutes: 15))) &&
                        DateTime.now().isBefore(DateTime.parse(note.reminder!))) {
                      fcmServices.sendPushMessage(
                          messageBody: note.title == "" && note.text == ""
                              ? "Reminder for you to check your note"
                              : note.title == ""
                                  ? "${note.text} is approaching. Check your notes. Thank You!"
                                  : "${note.title} is approaching. Check your notes. Thank You!");
                    }
                  }
                }
              }
            });

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: note.color ?? AppColors.transparent, width: 4)),
              color: Theme.of(context).primaryColor,
              elevation: 4,
              shadowColor: Theme.of(context).colorScheme.shadow,
              child: InkWell(
                onTap: () {
                  widget.onTap!(note);
                },
                onLongPress: () {
                  widget.onLongPress!(note);
                },
                child: GridTile(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        note.createdDate == ""
                            ? const SizedBox()
                            : Text(
                                DateFormat.yMMMd().format(DateTime.parse(note.createdDate!)),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontWeight: medium, fontSize: 9, color: Theme.of(context).hintColor),
                              ),
                        const SizedBox(height: 4),
                        Text(
                          note.title,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          note.text,
                          maxLines: 4,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            note.imageUrl == "" && note.fileUrl == ""
                                ? const SizedBox()
                                : note.imageUrl == ""
                                    ? const SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          if (note.imageUrl != "") {
                                            widget.onImageTap!(note.imageUrl!);
                                          }
                                        },
                                        child: Hero(
                                          tag: note.imageUrl!,
                                          child: Container(
                                            height: 34,
                                            width: 34,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).scaffoldBackgroundColor,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: "${note.imageUrl}",
                                                fit: BoxFit.cover,
                                                memCacheHeight: 50,
                                                errorWidget: (context, url, error) => Icon(
                                                  Icons.error,
                                                  color: Theme.of(context).colorScheme.background,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                            note.imageUrl == "" && note.fileUrl == ""
                                ? const SizedBox()
                                : SizedBox(width: note.imageUrl == "" ? 0 : 15),
                            note.imageUrl == "" && note.fileUrl == ""
                                ? const SizedBox()
                                : note.fileUrl == ""
                                    ? const SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          if (note.fileUrl != "") {
                                            widget.onFileTap!(
                                                Args(fileUrl: note.fileUrl!, fileName: note.fileName ?? ""));
                                          }
                                        },
                                        child: Container(
                                          height: 34,
                                          width: 34,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                              path.extension(note.fileName!) == ".pdf"
                                                  ? Icons.picture_as_pdf
                                                  : path.extension(note.fileName!) == ".pptx"
                                                      ? Icons.present_to_all
                                                      : Icons.file_copy,
                                              size: 20,
                                              color: Theme.of(context).colorScheme.background),
                                        ),
                                      ),
                            const Spacer(),
                            note.favourite == null
                                ? const SizedBox()
                                : note.favourite!
                                    ? Icon(Icons.star, color: Theme.of(context).indicatorColor)
                                    : const SizedBox()
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: widget.notes.length,
        ),
      ),
    );
  }
}

// SQFLITE USAGE
// typedef NoteCallback = void Function(DatabaseNote note);

// class NotesListView extends StatelessWidget {
//   final List<DatabaseNote> notes;
//   final NoteCallback? onDeleteNote;
//   final NoteCallback? onTap;
//   const NotesListView({Key? key, required this.notes, this.onDeleteNote, this.onTap}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: notes.length,
//         itemBuilder: (context, index) {
//           final note = notes[index];
//           return ListTile(
//             onTap: () {
//               onTap!(note);
//             },
//             title: Text(note.text, maxLines: 1, softWrap: true, overflow: TextOverflow.ellipsis),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete, color: AppColors.cRed),
//               onPressed: () async {
//                 final shouldDelete = await showDeleteDialog(context);
//                 if (shouldDelete) {
//                   onDeleteNote!(note);
//                 }
//               },
//             ),
//           );
//         });
//   }
// }
