import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notester/services/auth_services.dart';
import 'package:notester/services/cloud/cloud_checklist.dart';
import 'package:notester/services/cloud/firebase_cloud_storage.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/utils/constants.dart';
import 'package:notester/utils/dialogs/delete_dialog.dart';
import 'package:notester/view/checklists/checklist_list_view.dart';
import 'package:notester/view/route/routes.dart';
import 'package:notester/widgets/no_data_widget.dart';
import 'package:notester/widgets/simple_circular_loader.dart';

class ChecklistsScreen extends StatefulWidget {
  const ChecklistsScreen({super.key});

  @override
  State<ChecklistsScreen> createState() => _ChecklistsScreenState();
}

class _ChecklistsScreenState extends State<ChecklistsScreen> {
  late final FirebaseCloudStorage _notesService;
  final AuthServices _auth = AuthServices();

  String? get userId => _auth.currentUser == null ? "" : _auth.currentUser!.id;

  @override
  void initState() {
    debugPrint(userId);
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RemoveFocus(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Checklists'),
          actions: [
            IconButton(
              onPressed: () async {
                final checklist = await _notesService.createNewChecklist(
                    ownerUserId: userId!);
                if (context.mounted) {
                  _showChecklistDialog(context, checklist: checklist);
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: _notesService.allChecklists(ownerUserId: userId!),
          builder: (context, snapshot) {
            if (userId == null) {
              Utilities.removeNamedStackActivity(context, Routes.login);
            }

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allChecklists =
                      snapshot.data as Iterable<CloudChecklist>;

                  return allChecklists.isNotEmpty
                      ? CupertinoScrollbar(
                          child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              ChecklistListView(
                                checklists: allChecklists,
                                onTap: (checklist) {
                                  _showChecklistDialog(context,
                                      checklist: checklist);
                                },
                                onLongPress: (checklist) {
                                  showChecklistBottomSheet(
                                    context: context,
                                    checklist: checklist,
                                    onDeleteTap: () async {
                                      Utilities.closeActivity(context);
                                      final shouldDelete =
                                          await showDeleteDialog(context);
                                      if (shouldDelete) {
                                        await _notesService.deleteChecklist(
                                            documentId: checklist.documentId);
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: NoDataWidget(title: "No checklists available"),
                        );
                } else {
                  return const Center(child: SimpleCircularLoader());
                }

              default:
                return const Center(child: SimpleCircularLoader());
            }
          },
        ),
      ),
    );
  }

  void _showChecklistDialog(BuildContext context,
      {required CloudChecklist checklist}) {
    final titleController = TextEditingController(text: checklist.title);
    final items = List<ChecklistItem>.from(checklist.items);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(18),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: titleController,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: bold),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Checklist Title",
                    prefixIcon: Icon(Icons.checklist,
                        color: Theme.of(context).colorScheme.surface),
                    hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: medium),
                    border:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                )),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          leading: Checkbox(
                            value: items[index].isChecked,
                            checkColor: AppColors.cWhite,
                            onChanged: (value) {
                              setState(() {
                                items[index] = items[index]
                                    .copyWith(isChecked: value ?? false);
                              });
                            },
                          ),
                          title: Text(
                            items[index].text,
                            style: TextStyle(
                              decoration: items[index].isChecked
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: AppColors.cRedAccent),
                            onPressed: () {
                              setState(() {
                                items.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      final controller = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          title: Text('Add Item',
                              style: Theme.of(context).textTheme.titleSmall),
                          content: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                hintText: 'Item text',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyMedium),
                            autofocus: true,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancel',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (controller.text.isNotEmpty) {
                                  setState(() {
                                    items.add(ChecklistItem(
                                      id: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      text: controller.text,
                                      isChecked: false,
                                    ));
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                'Add',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.cWhite,
                    ),
                    label: Text(
                      'Add Item',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.cWhite),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary),
                ),
                onPressed: () async {
                  await _notesService.updateChecklist(
                    documentId: checklist.documentId,
                    title: titleController.text,
                    items: items,
                    createdDate: checklist.createdDate ??
                        DateTime.now().toIso8601String(),
                    favourite: checklist.favourite ?? false,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Save',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.cWhite),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  showChecklistBottomSheet({
    required BuildContext context,
    required CloudChecklist checklist,
    VoidCallback? onDeleteTap,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 24.h),
          child: Container(
            color: AppColors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: onDeleteTap,
                  leading:
                      const Icon(Icons.delete, color: AppColors.cRedAccent),
                  title: Text("Delete",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
