import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notester/model/model.dart';
import 'package:notester/provider/dark_theme_provider.dart';
import 'package:notester/services/auth_services.dart';
import 'package:notester/services/cloud/cloud_note.dart';
import 'package:notester/services/cloud/firebase_cloud_storage.dart';
import 'package:notester/services/fcm_services.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/utils/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:notester/utils/dialogs/delete_dialog.dart';
import 'package:notester/utils/utils.dart';
import 'package:notester/view/notes/notes_list_view.dart';
import 'package:notester/view/route/routes.dart';
import 'package:notester/widgets/default_loading_screen.dart';
import 'package:notester/widgets/no_data_widget.dart';
import 'package:notester/widgets/simple_circular_loader.dart';
import 'package:notester/widgets/sliver_header_text.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late final FirebaseCloudStorage _notesService;
  late final FcmServices fcmServices;

  final AuthServices _auth = AuthServices();

  String? get userId => _auth.currentUser == null ? "" : _auth.currentUser!.id;

  double top = 0.0;

  final _controller = ScrollController();

  double get maxHeight => 200 + MediaQuery.of(context).padding.top;

  double get minHeight => 120;

  late ValueNotifier<String> _filterValue;

  @override
  void initState() {
    debugPrint(userId);
    _filterValue = ValueNotifier<String>("");
    _notesService = FirebaseCloudStorage();
    fcmServices = FcmServices();
    super.initState();
  }

  void _snapAppBar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset =
          _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      Future.microtask(() => _controller.animateTo(snapOffset,
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }

  @override
  void dispose() {
    _filterValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: ValueListenableBuilder(
            valueListenable: _filterValue,
            builder: (context, task, _) {
              return StreamBuilder(
                stream: _filterValue.value == "fav"
                    ? _notesService.allFavouriteNotes(
                        ownerUserId: userId!, favourite: true)
                    : _notesService.allNotes(ownerUserId: userId!),
                builder: (context, snapshot) {
                  if (userId == null) {
                    Utilities.removeNamedStackActivity(context, Routes.login);
                  }

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as Iterable<CloudNote>;

                        return NotificationListener<ScrollEndNotification>(
                          onNotification: (_) {
                            _snapAppBar();
                            return false;
                          },
                          child: CupertinoScrollbar(
                            controller: _controller,
                            child: CustomScrollView(
                              controller: _controller,
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverAppBar(
                                  pinned: true,
                                  stretch: true,
                                  centerTitle: false,
                                  shadowColor:
                                      Theme.of(context).colorScheme.shadow,
                                  iconTheme: Theme.of(context)
                                      .appBarTheme
                                      .iconTheme
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline),
                                  flexibleSpace: SliverHeaderText(
                                      maxHeight: maxHeight,
                                      minHeight: minHeight,
                                      notesLength: allNotes.isEmpty
                                          ? 0
                                          : allNotes.length,
                                      onlyShowFavorite:
                                          _filterValue.value.toLowerCase() ==
                                                  'fav'
                                              ? true
                                              : false,
                                      imagePath: value.darkTheme
                                          ? "assets/notesImage.png"
                                          : "assets/notesImageLightNew.png"),
                                  expandedHeight: maxHeight -
                                      MediaQuery.of(context).padding.top,
                                  leading: StreamBuilder(
                                    stream: _notesService.userData(
                                        ownerUserId: userId!),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                        case ConnectionState.active:
                                          if (snapshot.hasData) {
                                            final userData = snapshot.data
                                                as Iterable<UserModel>;
                                            return userData.isEmpty
                                                ? const SizedBox.shrink()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Utilities
                                                            .openNamedActivity(
                                                                context,
                                                                Routes
                                                                    .settings);
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Theme
                                                                        .of(
                                                                            context)
                                                                    .primaryColor),
                                                            color: AppColors
                                                                .cDarkBlueAccent,
                                                            shape: BoxShape
                                                                .circle),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child:
                                                              CachedNetworkImage(
                                                            memCacheHeight: 200,
                                                            imageUrl: userData
                                                                    .first
                                                                    .profileImage ??
                                                                "",
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) => Center(
                                                                child: SimpleCircularLoader(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .outline)),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                Icon(
                                                                    Icons.image,
                                                                    color: AppColors
                                                                        .cLight,
                                                                    size: 26.h),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                          } else {
                                            return const SizedBox(
                                              height: 70,
                                              width: 70,
                                            );
                                          }

                                        default:
                                          return const Center(
                                            child: SimpleCircularLoader(),
                                          );
                                      }
                                    },
                                  ),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        Utilities.openNamedActivity(
                                            context, Routes.createUpdateNote);
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ),
                                    PopupMenuButton(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      elevation: 20,
                                      enabled: true,
                                      icon:
                                          const Icon(Icons.filter_list_rounded),
                                      tooltip: "Filter list",
                                      onSelected: (String value) {
                                        _filterValue.value = value;
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: "all",
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.list,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              const SizedBox(width: 12),
                                              Text("Show All",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: "fav",
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              const SizedBox(width: 12),
                                              Text("Only Favourites",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                if (allNotes.isNotEmpty)
                                  NotesListView(
                                    notes: allNotes,
                                    onTap: (note) {
                                      Utilities.openNamedActivity(
                                          context, Routes.createUpdateNote,
                                          arguments: note);
                                    },
                                    onImageTap: (imageUrl) {
                                      log(imageUrl);
                                      Utilities.openNamedActivity(
                                          context, Routes.notesImage,
                                          arguments:
                                              ImageArgs(imageUrl: imageUrl));
                                    },
                                    onFileTap: (fileArg) {
                                      if (path.extension(fileArg.fileName) ==
                                          ".pdf") {
                                        Utilities.openNamedActivity(
                                            context, Routes.pdfView,
                                            arguments: fileArg);
                                      } else {
                                        Utils.launchFile(fileArg.fileUrl);
                                      }
                                    },
                                    onLongPress: (note) {
                                      showBottomSheet(
                                        context: context,
                                        onDeleteTap: () async {
                                          Utilities.closeActivity(context);

                                          final shouldDelete =
                                              await showDeleteDialog(context);
                                          log(shouldDelete.toString());
                                          if (shouldDelete) {
                                            if (note.imageUrl != "") {
                                              _notesService
                                                  .deleteFile(note.imageUrl!);
                                            }
                                            if (note.fileUrl != "") {
                                              _notesService
                                                  .deleteFile(note.fileUrl!);
                                            }
                                            await _notesService.deleteNote(
                                                documentId: note.documentId);
                                          }
                                        },
                                        onShareTap: () async {
                                          Utilities.closeActivity(context);
                                          if (note.text.isEmpty) {
                                            await showCannotShareEmptyNoteDialog(
                                                context);
                                          } else {
                                            Share.share(note.text);
                                          }
                                        },
                                      );
                                    },
                                  )
                                else
                                  const SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Center(
                                      child: NoDataWidget(
                                          title: "No notes available"),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return DefaultLoadingScreen(
                          maxHeight: maxHeight,
                          minHeight: minHeight,
                          actions: [
                            IconButton(
                              onPressed: () {
                                Utilities.openNamedActivity(
                                    context, Routes.createUpdateNote);
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        );
                      }

                    default:
                      return DefaultLoadingScreen(
                        maxHeight: maxHeight,
                        minHeight: minHeight,
                        actions: [
                          IconButton(
                            onPressed: () {
                              Utilities.openNamedActivity(
                                  context, Routes.createUpdateNote);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  showBottomSheet(
      {required BuildContext context,
      VoidCallback? onDeleteTap,
      VoidCallback? onShareTap}) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return Container(
          color: AppColors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: onShareTap,
                leading: Icon(Icons.share,
                    color: Theme.of(context).colorScheme.surface),
                title:
                    Text("Share", style: Theme.of(context).textTheme.bodyLarge),
              ),
              ListTile(
                onTap: onDeleteTap,
                leading: const Icon(Icons.delete, color: AppColors.cRedAccent),
                title: Text("Delete",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),
        );
      },
    );
  }
}
