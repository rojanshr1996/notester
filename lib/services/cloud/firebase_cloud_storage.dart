import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:notester/services/cloud/cloud_note.dart';
import 'package:notester/services/cloud/cloud_storage_constants.dart';
import 'package:notester/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');
  final users = FirebaseFirestore.instance.collection('users');
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
            (event) => event.docs
                .map((doc) => CloudNote.fromSnapshot(doc))
                .where((note) => note.ownerUserId == ownerUserId),
          );

  Stream<Iterable<CloudNote>> allFavouriteNotes(
          {required String ownerUserId, bool favourite = true}) =>
      notes.snapshots().map(
            (event) => event.docs
                .map((doc) => CloudNote.fromSnapshot(doc))
                .where((note) =>
                    note.ownerUserId == ownerUserId &&
                    note.favourite == favourite),
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
}
