import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_widgets/custom_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:notester/cubit/pdf_download/pdf_download_cubit.dart';
import 'package:notester/cubit/pdf_download/pdf_download_state.dart';
import 'package:notester/model/model.dart';
import 'package:notester/services/auth_services.dart';
import 'package:notester/services/cloud/cloud_note.dart';
import 'package:notester/services/cloud/firebase_cloud_storage.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/utils/constants.dart';
import 'package:notester/utils/custom_text_style.dart';
import 'package:notester/utils/utils.dart';
import 'package:notester/view/notes/color_slider.dart';
import 'package:notester/view/route/routes.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';

class CreateUpdateNoteView extends StatefulWidget {
  final CloudNote? note;
  const CreateUpdateNoteView({super.key, this.note});

  @override
  CreateUpdateNoteViewState createState() => CreateUpdateNoteViewState();
}

class CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  final AuthServices auth = AuthServices();
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _titleController;
  late final TextEditingController _textController;
  late ValueNotifier<Color> _color;
  late ValueNotifier<File?> _imageFile;
  late ValueNotifier<File?> _file;
  late ValueNotifier<UploadTask?> _task;
  late ValueNotifier<UploadTask?> _taskFile;
  late ValueNotifier<String> _imageUrl;
  late ValueNotifier<String> _fileUrl;
  late ValueNotifier<String> _fileName;
  late ValueNotifier<String> _reminder;
  late ValueNotifier<String> _createdDate;
  double progress = 0.0;
  bool favourite = false;

  @override
  void initState() {
    _color = ValueNotifier<Color>(AppColors.cWhite);
    _imageFile = ValueNotifier<File?>(null);
    _file = ValueNotifier<File?>(null);
    _task = ValueNotifier<UploadTask?>(null);
    _taskFile = ValueNotifier<UploadTask?>(null);
    _imageUrl = ValueNotifier<String>("");
    _fileUrl = ValueNotifier<String>("");
    _fileName = ValueNotifier<String>("");
    _reminder = ValueNotifier<String>("");
    _createdDate = ValueNotifier<String>("");
    _notesService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _textController = TextEditingController();
    super.initState();
  }

  void _titleControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    final title = _titleController.text.trim();
    await _notesService.updateNote(
      documentId: note.documentId,
      createdDate: _createdDate.value == "" ? "${DateTime.now()}" : _createdDate.value,
      // createdDate: "${DateTime.now()}",
      text: text,
      title: title,
      imageUrl: _imageUrl.value,
      fileUrl: _fileUrl.value,
      fileName: _fileName.value,
      favourite: favourite,
      reminder: _reminder.value,
    );
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text.trim();
    final title = _titleController.text.trim();
    await _notesService.updateNote(
      documentId: note.documentId,
      createdDate: _createdDate.value == "" ? "${DateTime.now()}" : _createdDate.value,
      // createdDate: "${DateTime.now()}",
      text: text,
      title: title,
      imageUrl: _imageUrl.value,
      fileUrl: _fileUrl.value,
      fileName: _fileName.value,
      favourite: favourite,
      reminder: _reminder.value,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
    _titleController.removeListener(_titleControllerListener);
    _titleController.addListener(_titleControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    // final widget.note = context.getArgument<CloudNote>();

    if (widget.note != null) {
      _note = widget.note;
      if (_note?.color != null) {
        _color.value = _note!.color!;
      }
      _textController.text = widget.note!.text;
      _titleController.text = widget.note!.title;

      if (_note!.imageUrl != "") {
        if (_imageUrl.value == "" || _imageUrl.value == _note!.imageUrl) {
          _imageUrl.value = _note!.imageUrl!;
          // setState(() {});
        }
      }
      if (_note!.fileUrl != "") {
        if (_fileUrl.value == "" || _fileUrl.value == _note!.fileUrl) {
          _fileUrl.value = _note!.fileUrl!;
          // setState(() {});
        }
      }
      if (_note!.fileName != "") {
        if (_fileName.value == "" || _fileName.value == _note!.fileName) {
          _fileName.value = _note!.fileName!;
          // setState(() {});
        }
      }
      if (_note!.favourite != null) {
        favourite = _note!.favourite!;
      }
      if (_note!.reminder != "") {
        _reminder.value = _note!.reminder!;
      }
      if (_note!.createdDate != "") {
        _createdDate.value = _note!.createdDate!;
      }
      return widget.note!;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthServices().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null && _imageUrl.value == "" && _fileUrl.value == "") {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text.trim();
    final title = _titleController.text.trim();
    final color = _color.value;

    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: note.documentId,
        createdDate: _createdDate.value == "" ? "${DateTime.now()}" : _createdDate.value,
        // createdDate: "${DateTime.now()}",
        text: text,
        title: title,
        color: "${color.value}",
        imageUrl: _imageUrl.value,
        fileUrl: _fileUrl.value,
        fileName: _fileName.value,
        favourite: favourite,
        reminder: _reminder.value,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    _titleController.dispose();
    _imageFile.dispose();
    _file.dispose();
    _imageUrl.dispose();
    _fileUrl.dispose();
    _color.dispose();
    _task.dispose();
    _taskFile.dispose();
    _reminder.dispose();
    _createdDate.dispose();
    super.dispose();
  }

  addImage(BuildContext context) async {
    final result = await Utils.addImage(context);

    if (result != null) {
      if (_imageUrl.value != "") {
        _notesService.deleteFile(_imageUrl.value);
      }
      _imageUrl.value = "";
      _saveNoteIfTextNotEmpty();
      _imageFile.value = File(result.path);
      uploadImage();
    }
  }

  addFile(BuildContext context) async {
    final result = await Utils.addFile(context);

    if (result != null) {
      if (_fileUrl.value != "") {
        _notesService.deleteFile(_fileUrl.value);
      }
      _fileUrl.value = "";
      _saveNoteIfTextNotEmpty();
      _file.value = result;
      uploadFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PdfDownloadCubit, PdfDownloadState>(
      listener: (context, state) {
        if (state is PdfDownloadLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Generating PDF...'),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        } else if (state is PdfDownloadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'PDF saved to: ${state.filePath}',
                style: const TextStyle(color: AppColors.cWhite),
              ),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
              backgroundColor: AppColors.cGreen,
            ),
          );
        } else if (state is PdfDownloadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: RemoveFocus(
        child: Scaffold(
          appBar: AppBar(
            // shadowColor: Theme.of(context).colorScheme.shadow,
            // backgroundColor: Theme.of(context).colorScheme.onPrimary,
            // elevation: 2,
            title: const Text("Add note"),
            actions: [
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  _downloadNoteAsPdf(context);
                },
                tooltip: 'Download as PDF',
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Utilities.closeActivity(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                  ),
                  child: Text(
                    "Save",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.cWhite),
                  ),
                ),
              ),
            ],
          ),
          body: FutureBuilder(
            future: createOrGetExistingNote(context),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _setupTextControllerListener();
                  return ValueListenableBuilder(
                    valueListenable: _color,
                    builder: (context, color, _) {
                      return Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                                        ),
                                        icon: const Icon(
                                          Icons.image,
                                          size: 18,
                                          color: AppColors.cWhite,
                                        ),
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          addImage(context);
                                        },
                                        label: Text(
                                          "Add Image",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: AppColors.cWhite, fontWeight: medium),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
                                        ),
                                        icon: const Icon(
                                          Icons.file_copy,
                                          size: 18,
                                          color: AppColors.cWhite,
                                        ),
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          addFile(context);
                                        },
                                        label: Text(
                                          "Add File",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: AppColors.cWhite, fontWeight: medium),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        child: Row(
                                          children: [
                                            ValueListenableBuilder(
                                              valueListenable: _createdDate,
                                              builder: (context, createdDate, _) {
                                                return Expanded(
                                                  child: _createdDate.value == ""
                                                      ? const SizedBox()
                                                      : Text(
                                                          DateFormat.yMMMMd()
                                                              .format(DateTime.parse(_createdDate.value)),
                                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                              fontWeight: medium, color: Theme.of(context).hintColor),
                                                        ),
                                                );
                                              },
                                            ),
                                            const Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                // OutlinedButton.icon(
                                                //   icon: Icon(
                                                //     Icons.access_time,
                                                //     size: 16,
                                                //     color: Theme.of(context).colorScheme.surface,
                                                //   ),
                                                //   onPressed: () {
                                                //     date_time_picker.DatePicker.showDateTimePicker(
                                                //       context,
                                                //       showTitleActions: true,
                                                //       minTime: DateTime.now(),
                                                //       currentTime: DateTime.now(),
                                                //       maxTime: DateTime(2200, 1, 1),
                                                //       onConfirm: (date) {
                                                //         _reminder.value = date.toString();
                                                //       },
                                                //       locale: date_time_picker.LocaleType.en,
                                                //     );
                                                //   },
                                                //   label: Text(
                                                //     "Reminder",
                                                //     style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                //         color: Theme.of(context).colorScheme.surface, fontWeight: medium),
                                                //   ),
                                                // ),
                                                // ValueListenableBuilder(
                                                //   valueListenable: _reminder,
                                                //   builder: (context, reminder, _) {
                                                //     return Row(
                                                //       children: [
                                                //         _reminder.value == ""
                                                //             ? const SizedBox()
                                                //             : InkWell(
                                                //                 onTap: () {
                                                //                   _reminder.value = "";
                                                //                 },
                                                //                 child: const Icon(Icons.close,
                                                //                     size: 14, color: AppColors.cRed),
                                                //               ),
                                                //         const SizedBox(width: 8),
                                                //         Text(
                                                //           _reminder.value == ""
                                                //               ? ""
                                                //               : "${DateFormat.yMMMMd().format(DateTime.parse(_reminder.value))}, ${DateFormat.jm().format(DateTime.parse(_reminder.value))}",
                                                //           style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                //               fontWeight: medium,
                                                //               fontSize: 10,
                                                //               color: Theme.of(context).hintColor),
                                                //         ),
                                                //       ],
                                                //     );
                                                //   },
                                                // ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16, right: 12),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: AppColors.cWhite),
                                                    color: _color.value),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: TextField(
                                                controller: _titleController,
                                                keyboardType: TextInputType.multiline,
                                                style:
                                                    Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: bold),
                                                maxLines: null,
                                                textCapitalization: TextCapitalization.sentences,
                                                decoration: InputDecoration(
                                                  hintText: "Enter title... ",
                                                  hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                      color: Theme.of(context).colorScheme.surface, fontWeight: medium),
                                                  border: const UnderlineInputBorder(borderSide: BorderSide.none),
                                                ),
                                              ),
                                            ),
                                            LikeButton(
                                              size: 36,
                                              isLiked: favourite,
                                              likeBuilder: (bool isLiked) {
                                                favourite = isLiked;
                                                return Icon(
                                                  isLiked ? Icons.star : Icons.star_border,
                                                  color:
                                                      isLiked ? Theme.of(context).indicatorColor : AppColors.cFadedBlue,
                                                  size: 36,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: TextField(
                                          controller: _textController,
                                          keyboardType: TextInputType.multiline,
                                          textCapitalization: TextCapitalization.sentences,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(fontWeight: regular, height: 1.4),
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            hintText: "Enter new note... ",
                                            hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                color: Theme.of(context).colorScheme.surface, fontWeight: regular),
                                            border: const UnderlineInputBorder(borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: ValueListenableBuilder(
                                      valueListenable: _imageFile,
                                      builder: (context, imageFile, _) {
                                        return _imageFile.value == null || _imageFile.value?.path == null
                                            ? ValueListenableBuilder(
                                                valueListenable: _imageUrl,
                                                builder: (context, imageUrl, _) {
                                                  return _imageUrl.value != ""
                                                      ? Padding(
                                                          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(15),
                                                            child: Column(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Utilities.openNamedActivity(
                                                                        context, Routes.enlargeImage,
                                                                        arguments:
                                                                            ImageArgs(imageUrl: _imageUrl.value));
                                                                  },
                                                                  child: Container(
                                                                    height: 140,
                                                                    width: double.maxFinite,
                                                                    color: AppColors.cWhite,
                                                                    child: CachedNetworkImage(
                                                                      imageUrl: _imageUrl.value,
                                                                      fit: BoxFit.cover,
                                                                      memCacheHeight: 450,
                                                                      errorWidget: (context, url, error) => Icon(
                                                                        Icons.error,
                                                                        color: Theme.of(context).colorScheme.surface,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    _imageFile.value = null;
                                                                    if (_imageUrl.value != "") {
                                                                      _notesService.deleteFile(_imageUrl.value);
                                                                      _imageUrl.value = "";
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                    height: 42,
                                                                    width: double.maxFinite,
                                                                    color: AppColors.cRedAccent,
                                                                    child: const Center(
                                                                      child: Icon(
                                                                        Icons.close,
                                                                        color: AppColors.cWhite,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox();
                                                },
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 140,
                                                        width: double.maxFinite,
                                                        color: AppColors.cWhite,
                                                        child: Image.file(_imageFile.value!,
                                                            fit: BoxFit.cover, cacheHeight: 500),
                                                      ),
                                                      ValueListenableBuilder(
                                                        valueListenable: _task,
                                                        builder: (context, task, _) {
                                                          return task != null
                                                              ? buildUploadStatus(_task.value!)
                                                              : const SizedBox();
                                                        },
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          _imageFile.value = null;
                                                          if (_imageUrl.value != "") {
                                                            _notesService.deleteFile(_imageUrl.value);
                                                            _imageUrl.value = "";
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 42,
                                                          width: 200,
                                                          color: AppColors.cRedAccent,
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.close,
                                                              color: AppColors.cWhite,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ValueListenableBuilder(
                                      valueListenable: _file,
                                      builder: (context, fileUrl, _) {
                                        return _file.value == null || _file.value?.path == null
                                            ? ValueListenableBuilder(
                                                valueListenable: _fileUrl,
                                                builder: (context, fileUrl, _) {
                                                  return _fileUrl.value != ""
                                                      ? Padding(
                                                          padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(15),
                                                            child: Column(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Utilities.openNamedActivity(context, Routes.pdfView,
                                                                        arguments: Args(
                                                                            fileUrl: _fileUrl.value,
                                                                            fileName: widget.note!.fileName ?? ""));
                                                                  },
                                                                  child: Container(
                                                                    height: 140,
                                                                    width: double.maxFinite,
                                                                    color: AppColors.cWhite,
                                                                    child: Center(
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                              path.extension(widget.note!.fileName!) ==
                                                                                      ".pdf"
                                                                                  ? Icons.picture_as_pdf
                                                                                  : path.extension(
                                                                                              widget.note!.fileName!) ==
                                                                                          ".pptx"
                                                                                      ? Icons.present_to_all
                                                                                      : Icons.file_copy,
                                                                              size: 48,
                                                                              color: AppColors.cDarkBlue),
                                                                          const SizedBox(height: 10),
                                                                          Text(
                                                                            "${widget.note?.fileName}",
                                                                            textAlign: TextAlign.center,
                                                                            maxLines: 2,
                                                                            style: CustomTextStyle.smallText,
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    _file.value = null;
                                                                    if (_fileUrl.value != "") {
                                                                      _notesService.deleteFile(_fileUrl.value);
                                                                      _fileUrl.value = "";
                                                                      _fileName.value = "";
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                    height: 42,
                                                                    width: 200,
                                                                    color: AppColors.cRedAccent,
                                                                    child: const Center(
                                                                      child: Icon(
                                                                        Icons.close,
                                                                        color: AppColors.cWhite,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox();
                                                },
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: 140,
                                                        width: double.maxFinite,
                                                        color: AppColors.cWhite,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(
                                                                path.extension(_file.value!.path) == ".pdf"
                                                                    ? Icons.picture_as_pdf
                                                                    : path.extension(_file.value!.path) == ".pptx"
                                                                        ? Icons.present_to_all
                                                                        : Icons.file_copy,
                                                                size: 48,
                                                                color: AppColors.cDarkBlue),
                                                            const SizedBox(height: 10),
                                                            Text(
                                                              _file.value!.path.split("/").last,
                                                              textAlign: TextAlign.center,
                                                              maxLines: 2,
                                                              style: CustomTextStyle.smallText,
                                                              overflow: TextOverflow.ellipsis,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      ValueListenableBuilder(
                                                        valueListenable: _taskFile,
                                                        builder: (context, task, _) {
                                                          return task != null
                                                              ? buildFileUploadStatus(_taskFile.value!)
                                                              : const SizedBox();
                                                        },
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          _file.value = null;
                                                          if (_fileUrl.value != "") {
                                                            _notesService.deleteFile(_fileUrl.value);
                                                            _fileUrl.value = "";
                                                            _fileName.value = "";
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 42,
                                                          width: 200,
                                                          color: AppColors.cRedAccent,
                                                          child: const Center(
                                                            child: Icon(Icons.close, color: AppColors.cWhite),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                                child: SizedBox(
                                  height: 100.h,
                                  child: ColorSlider(
                                    noteColor: _color.value,
                                    callBackColorTapped: (color) {
                                      _color.value = color;
                                      _saveNoteIfTextNotEmpty();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                default:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  void _downloadNoteAsPdf(BuildContext context) {
    final title = _titleController.text.trim();
    final content = _textController.text.trim();
    final createdDate = _createdDate.value.isEmpty
        ? DateFormat.yMMMMd().format(DateTime.now())
        : DateFormat.yMMMMd().format(DateTime.parse(_createdDate.value));

    if (content.isEmpty && title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot download empty note'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<PdfDownloadCubit>().downloadNoteAsPdf(
          title: title,
          content: content,
          createdDate: createdDate,
        );
  }

  Future uploadImage() async {
    if (_imageFile.value == null) return;
    final fileName = basename(_imageFile.value!.path);
    _task.value = _notesService.uploadFile(fileName, _imageFile.value!);

    if (_task.value == null) return;
    final snapshot = await _task.value!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    _imageUrl.value = urlDownload;
    _saveNoteIfTextNotEmpty();
  }

  Future uploadFile() async {
    if (_file.value == null) return;
    final fileName = basename(_file.value!.path);
    _taskFile.value = _notesService.uploadFile("$fileName${DateTime.now()}", _file.value!);

    if (_taskFile.value == null) return;
    final snapshot = await _taskFile.value!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    _fileUrl.value = urlDownload;
    _fileName.value = _file.value!.path.split("/").last;
    _saveNoteIfTextNotEmpty();
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            return progress == 1.0
                ? const SizedBox()
                : Container(
                    width: 200,
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.cLight,
                      color: AppColors.cGreen,
                      minHeight: 10,
                    ),
                  );
          } else {
            return Container(height: 10, width: 200, color: AppColors.cWhite);
          }
        },
      );

  Widget buildFileUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            return progress == 1.0
                ? const SizedBox()
                : Container(
                    width: 200,
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.cLight,
                      color: AppColors.cGreen,
                      minHeight: 10,
                    ),
                  );
          } else {
            return Container(height: 10, width: 200, color: AppColors.cWhite);
          }
        },
      );
}
