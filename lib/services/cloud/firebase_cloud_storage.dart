import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:notester/services/cloud/cloud_checklist.dart';
import 'package:notester/services/cloud/cloud_note.dart';
import 'package:notester/services/cloud/cloud_storage_constants.dart';
import 'package:notester/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');
  final users = FirebaseFirestore.instance.collection('users');
  final checklists = FirebaseFirestore.instance.collection('checklists');
  final storageDestination = "attachments/";
  final storageUserDestination = "users/";
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldname: '',
      titleFieldname: '',
      colorFieldname: '',
      imageUrlFieldname: '',
      fileUrlFieldname: '',
      createdDateFieldName: '',
      fileFieldname: '',
      favouriteFieldName: '',
      reminderFieldName: '',
    });

    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: "",
      title: "",
      imageUrl: "",
      fileUrl: "",
      createdDate: "",
      fileName: "",
      favourite: false,
      reminder: "",
    );
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map(
        (event) {
          final userNotes = event.docs
              .map((doc) => CloudNote.fromSnapshot(doc))
              .where((note) => note.ownerUserId == ownerUserId)
              .toList();

          // Sort: favorites first, then by creation date (newest first)
          userNotes.sort((a, b) {
            // First, sort by favorite status
            if (a.favourite == true && b.favourite != true) return -1;
            if (a.favourite != true && b.favourite == true) return 1;

            // Then sort by creation date (newest first)
            if (a.createdDate != null &&
                a.createdDate!.isNotEmpty &&
                b.createdDate != null &&
                b.createdDate!.isNotEmpty) {
              try {
                final dateA = DateTime.parse(a.createdDate!);
                final dateB = DateTime.parse(b.createdDate!);
                return dateB.compareTo(dateA);
              } catch (e) {
                return 0;
              }
            }
            return 0;
          });

          return userNotes;
        },
      );

  Stream<Iterable<CloudNote>> allFavouriteNotes(
          {required String ownerUserId, bool favourite = true}) =>
      notes.snapshots().map(
        (event) {
          final favoriteNotes = event.docs
              .map((doc) => CloudNote.fromSnapshot(doc))
              .where((note) =>
                  note.ownerUserId == ownerUserId &&
                  note.favourite == favourite)
              .toList();

          // Sort by creation date (newest first)
          favoriteNotes.sort((a, b) {
            if (a.createdDate != null &&
                a.createdDate!.isNotEmpty &&
                b.createdDate != null &&
                b.createdDate!.isNotEmpty) {
              try {
                final dateA = DateTime.parse(a.createdDate!);
                final dateB = DateTime.parse(b.createdDate!);
                return dateB.compareTo(dateA);
              } catch (e) {
                return 0;
              }
            }
            return 0;
          });

          return favoriteNotes;
        },
      );

  Future<void> updateNote({
    required String documentId,
    required String text,
    required String title,
    String color = "",
    String imageUrl = "",
    String fileUrl = "",
    String createdDate = "",
    String fileName = "",
    bool favourite = false,
    String reminder = "",
  }) async {
    try {
      await notes.doc(documentId).update({
        textFieldname: text,
        titleFieldname: title,
        colorFieldname: color,
        imageUrlFieldname: imageUrl,
        fileUrlFieldname: fileUrl,
        createdDateFieldName: createdDate,
        fileFieldname: fileName,
        favouriteFieldName: favourite,
        reminderFieldName: reminder,
      });
    } catch (e) {
      throw CouldNotGetUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotGetDeleteNoteException();
    }
  }

  UploadTask? uploadFile(String fileName, File file, {bool fromUser = false}) {
    try {
      if (fromUser) {
        final ref =
            FirebaseStorage.instance.ref("$storageUserDestination$fileName");
        return ref.putFile(file);
      }
      final ref = FirebaseStorage.instance.ref("$storageDestination$fileName");
      return ref.putFile(file);
    } catch (e) {
      throw CouldNotUploadImage();
    }
  }

  UploadTask? uploadBytes(String fileName, Uint8List bytes) {
    try {
      final ref = FirebaseStorage.instance.ref("$storageDestination$fileName");
      return ref.putData(bytes);
    } catch (e) {
      throw CouldNotUploadImage();
    }
  }

  Future<void> deleteFile(String file) async {
    try {
      await FirebaseStorage.instance.refFromURL(file).delete();
    } catch (e) {
      throw CouldNotUploadImage();
    }
  }

  // User Collection
  Future<Iterable<UserModel>> getUser({required String ownerUserId}) async {
    try {
      return await users
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) => value.docs.map((doc) => UserModel.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetUserException();
    }
  }

  Stream<Iterable<UserModel>> userData({required String ownerUserId}) =>
      users.snapshots().map(
            (event) => event.docs
                .map((doc) => UserModel.fromSnapshot(doc))
                .where((user) => user.userId == ownerUserId),
          );

  Future<void> updateUser({
    required String documentId,
    required String name,
    String phone = "",
    String address = "",
    String profileUrl = "",
  }) async {
    try {
      await users.doc(documentId).update({
        fullNameFieldName: name,
        profileImageFieldName: profileUrl,
        phoneFieldName: phone,
        addressFieldName: address
      });
    } catch (e) {
      throw CouldNotGetUpdateUserException();
    }
  }

  // Checklist Collection
  Future<CloudChecklist> createNewChecklist(
      {required String ownerUserId}) async {
    final document = await checklists.add({
      ownerUserIdFieldName: ownerUserId,
      checklistTitleFieldName: '',
      checklistItemsFieldName: [],
      createdDateFieldName: '',
      favouriteFieldName: false,
    });

    final fetchedChecklist = await document.get();
    return CloudChecklist(
      documentId: fetchedChecklist.id,
      ownerUserId: ownerUserId,
      title: "",
      items: const [],
      createdDate: "",
      favourite: false,
    );
  }

  Stream<Iterable<CloudChecklist>> allChecklists(
          {required String ownerUserId}) =>
      checklists.snapshots().map(
        (event) {
          final userChecklists = event.docs
              .map((doc) => CloudChecklist.fromSnapshot(doc))
              .where((checklist) => checklist.ownerUserId == ownerUserId)
              .toList();

          // Sort: favorites first, then by creation date (newest first)
          userChecklists.sort((a, b) {
            final aFav = a.favourite ?? false;
            final bFav = b.favourite ?? false;
            if (aFav && !bFav) return -1;
            if (!aFav && bFav) return 1;

            final aDate = a.createdDate;
            final bDate = b.createdDate;
            if (aDate != null &&
                aDate.isNotEmpty &&
                bDate != null &&
                bDate.isNotEmpty) {
              try {
                final dateA = DateTime.parse(aDate);
                final dateB = DateTime.parse(bDate);
                return dateB.compareTo(dateA);
              } catch (e) {
                return 0;
              }
            }
            return 0;
          });

          return userChecklists;
        },
      );

  Stream<Iterable<CloudChecklist>> allFavouriteChecklists({
    required String ownerUserId,
    bool favourite = true,
  }) =>
      checklists.snapshots().map(
        (event) {
          final favoriteChecklists = event.docs
              .map((doc) => CloudChecklist.fromSnapshot(doc))
              .where((checklist) {
            final isFav = checklist.favourite ?? false;
            return checklist.ownerUserId == ownerUserId && isFav == favourite;
          }).toList();

          favoriteChecklists.sort((a, b) {
            final aDate = a.createdDate;
            final bDate = b.createdDate;
            if (aDate != null &&
                aDate.isNotEmpty &&
                bDate != null &&
                bDate.isNotEmpty) {
              try {
                final dateA = DateTime.parse(aDate);
                final dateB = DateTime.parse(bDate);
                return dateB.compareTo(dateA);
              } catch (e) {
                return 0;
              }
            }
            return 0;
          });

          return favoriteChecklists;
        },
      );

  Future<void> updateChecklist({
    required String documentId,
    required String title,
    required List<ChecklistItem> items,
    String createdDate = "",
    bool favourite = false,
  }) async {
    try {
      await checklists.doc(documentId).update({
        checklistTitleFieldName: title,
        checklistItemsFieldName: items.map((item) => item.toMap()).toList(),
        createdDateFieldName: createdDate,
        favouriteFieldName: favourite,
      });
    } catch (e) {
      throw CouldNotGetUpdateNoteException();
    }
  }

  Future<void> deleteChecklist({required String documentId}) async {
    try {
      await checklists.doc(documentId).delete();
    } catch (e) {
      throw CouldNotGetDeleteNoteException();
    }
  }
}
