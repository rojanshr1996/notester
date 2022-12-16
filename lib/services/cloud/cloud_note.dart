import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notester/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final String title;
  final Color? color;
  final String? imageUrl;
  final String? createdDate;
  final String? fileUrl;
  final String? fileName;
  final bool? favourite;
  final String? reminder;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.title,
    this.createdDate,
    this.color,
    this.imageUrl,
    this.fileUrl,
    this.fileName,
    this.favourite,
    this.reminder,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldname] as String,
        title = snapshot.data()[titleFieldname] as String,
        color = _parseColor(snapshot.data()[colorFieldname]),
        imageUrl = snapshot.data()[imageUrlFieldname] as String,
        createdDate = snapshot.data()[createdDateFieldName] as String,
        fileUrl = snapshot.data()[fileUrlFieldname] as String,
        fileName = snapshot.data()[fileFieldname] as String,
        favourite = snapshot.data()[favouriteFieldName] == "" ? false : snapshot.data()[favouriteFieldName] as bool?,
        reminder = snapshot.data()[reminderFieldName] as String?;
}

Color? _parseColor(String? colorInt) =>
    colorInt == null || colorInt == "" ? const Color(0xFFFFFFFF) : Color(int.parse(colorInt));

class UserModel {
  String? documentId;
  String? name;
  String? email;
  String? profileImage;
  String? userId;
  String? phone;
  String? address;
  String? createdDate;
  String? updatedDate;

  UserModel(
      {this.name,
      this.email,
      this.profileImage,
      this.userId,
      this.phone,
      this.address,
      this.createdDate,
      this.updatedDate});

  @override
  String toString() {
    return 'UserModel(name: $name, placeId: $email, placeName: $phone, userId: $userId, createdDate: $createdDate)';
  }

  UserModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        name = snapshot.data()[fullNameFieldName] as String,
        email = snapshot.data()[emailFieldName] as String,
        profileImage = snapshot.data()[profileImageFieldName] as String,
        userId = snapshot.data()[ownerUserIdFieldName],
        phone = snapshot.data()[phoneFieldName] as String,
        address = snapshot.data()[addressFieldName] as String,
        createdDate = snapshot.data()[createdDateFieldName] as String,
        updatedDate = snapshot.data()[updatedDateFieldName] as String;
}
