import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_widgets/custom_widgets.dart';
import 'package:notester/services/auth_services.dart';
import 'package:notester/services/cloud/cloud_note.dart';
import 'package:notester/services/cloud/firebase_cloud_storage.dart';
import 'package:notester/utils/app_colors.dart';
import 'package:notester/utils/utils.dart';
import 'package:notester/view/profile/edit_profile_dialog.dart';
import 'package:notester/widgets/simple_circular_loader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? profileData;

  const ProfileScreen({Key? key, this.profileData}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final FirebaseCloudStorage _notesService;
  final AuthServices _auth = AuthServices();
  String? get userId => _auth.currentUser == null ? "" : _auth.currentUser!.id;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Iterable<UserModel> userData = [];
  late ValueNotifier<File?> _imageFile;
  late ValueNotifier<String> _imageUrl;
  late ValueNotifier<UploadTask?> _task;
  double progress = 0.0;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _imageFile = ValueNotifier<File?>(null);
    _imageUrl = ValueNotifier<String>("");
    _task = ValueNotifier<UploadTask?>(null);

    super.initState();
  }

  initialData() {
    if (widget.profileData != null) {
      nameController = TextEditingController(text: widget.profileData?.name);
      phoneController = TextEditingController(text: widget.profileData?.phone);
      addressController = TextEditingController(text: widget.profileData?.address);
      _imageUrl.value = widget.profileData!.profileImage!;
    }
  }

  @override
  void dispose() {
    addressController.dispose();
    nameController.dispose();
    phoneController.dispose();
    _imageFile.dispose();
    _imageUrl.dispose();

    _task.dispose();
    super.dispose();
  }

  addImage(BuildContext context) async {
    final result = await Utils.addImage(context);

    if (result != null) {
      if (_imageUrl.value != "") {
        _notesService.deleteFile(_imageUrl.value);
      }
      _imageUrl.value = "";
      addressController.text = userData.first.address!;
      nameController.text = userData.first.name!;
      phoneController.text = userData.first.phone!;
      _updateUser();
      _imageFile.value = File(result.path);
      uploadImage();
    }
  }

  void _updateUser() async {
    final userDoc = userData.first;
    final name = nameController.text.trim();
    final address = addressController.text.trim();
    final phone = phoneController.text.trim();
    final profileUrl = _imageUrl.value;

    await _notesService.updateUser(
      documentId: userDoc.documentId!,
      name: name,
      address: address,
      phone: phone,
      profileUrl: profileUrl,
    );
  }

  Future uploadImage() async {
    if (_imageFile.value == null) return;
    final fileName = basename(_imageFile.value!.path);
    _task.value = _notesService.uploadFile(fileName, _imageFile.value!, fromUser: true);

    if (_task.value == null) return;
    final snapshot = await _task.value!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    _imageUrl.value = urlDownload;
    _updateUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _notesService.userData(ownerUserId: userId!),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              userData = snapshot.data as Iterable<UserModel>;
              _imageUrl.value = userData.first.profileImage!;
              return IgnorePointer(
                ignoring: _task.value?.snapshot.bytesTransferred != _task.value?.snapshot.totalBytes ? true : false,
                child: Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: AppBar(
                    shadowColor: Theme.of(context).colorScheme.shadow,
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 2,
                    title: const Text("User Profile"),
                    actions: [
                      userData.isEmpty
                          ? const SizedBox()
                          : IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    addressController.text = userData.first.address!;
                                    nameController.text = userData.first.name!;
                                    phoneController.text = userData.first.phone!;
                                    return EditProfileDialog(
                                      addressController: addressController,
                                      nameController: nameController,
                                      phoneController: phoneController,
                                      formKey: formKey,
                                      onUpdate: () {
                                        FocusScope.of(context).unfocus();
                                        Utilities.closeActivity(context);
                                        _updateUser();
                                      },
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                    ],
                  ),
                  body: SizedBox(
                    height: Utilities.screenHeight(context),
                    width: Utilities.screenWidth(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            addImage(context);
                          },
                          child: Stack(
                            children: [
                              Container(
                                  height: Utilities.screenHeight(context) * 0.4,
                                  width: Utilities.screenWidth(context),
                                  decoration: const BoxDecoration(color: AppColors.cDarkBlue),
                                  child: ValueListenableBuilder(
                                    valueListenable: _imageFile,
                                    builder: (context, imageFile, _) {
                                      return _imageFile.value == null || _imageFile.value?.path == null
                                          ? ValueListenableBuilder(
                                              valueListenable: _imageUrl,
                                              builder: (context, imageUrl, _) {
                                                return _imageUrl.value == ""
                                                    ? const SizedBox()
                                                    : CachedNetworkImage(
                                                        imageUrl: userData.first.profileImage!,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) =>
                                                            const Center(child: SimpleCircularLoader()),
                                                        errorWidget: (context, url, error) => const Icon(
                                                          Icons.image,
                                                          color: AppColors.cLight,
                                                          size: 48,
                                                        ),
                                                      );
                                              },
                                            )
                                          : Image.file(_imageFile.value!, fit: BoxFit.cover, cacheHeight: 500);
                                    },
                                  )),
                              Container(
                                height: Utilities.screenHeight(context) * 0.4,
                                width: Utilities.screenWidth(context),
                                decoration: BoxDecoration(color: AppColors.cBlackShadow),
                                child: Center(
                                  child: Container(
                                    decoration:
                                        const BoxDecoration(color: AppColors.cDarkBlueAccent, shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Icon(
                                        Icons.photo_library,
                                        color: AppColors.cDarkBlueLight,
                                        size: Utilities.screenHeight(context) * 0.06,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _task,
                          builder: (context, task, _) {
                            return task != null ? buildUploadStatus(_task.value!) : const SizedBox();
                          },
                        ),
                        // const SizedBox(height: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              width: Utilities.screenWidth(context),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        Icons.person,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      title: Text(
                                        " ${userData.first.name}",
                                        style: Theme.of(context).textTheme.displaySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    ListTile(
                                      leading: Icon(
                                        Icons.email,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      title: Text(
                                        " ${userData.first.email}",
                                        style: Theme.of(context).textTheme.displaySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    ListTile(
                                      leading: Icon(
                                        Icons.phone,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      title: Text(
                                        " ${userData.first.phone}",
                                        style: Theme.of(context).textTheme.displaySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    userData.first.address == ""
                                        ? const SizedBox()
                                        : ListTile(
                                            leading: Icon(
                                              Icons.phone,
                                              color: Theme.of(context).colorScheme.secondary,
                                            ),
                                            title: Text(
                                              " ${userData.first.address}",
                                              style: Theme.of(context).textTheme.displaySmall,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }

          default:
            return const Center(
              child: SimpleCircularLoader(),
            );
        }
      },
    );
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            progress = snap.bytesTransferred / snap.totalBytes;
            return progress == 1.0
                ? const SizedBox()
                : Container(
                    width: Utilities.screenWidth(context),
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
