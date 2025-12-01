import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:notester/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudChecklist {
  final String documentId;
  final String ownerUserId;
  final String title;
  final List<ChecklistItem> items;
  final String? createdDate;
  final bool? favourite;

  const CloudChecklist({
    required this.documentId,
    required this.ownerUserId,
    required this.title,
    required this.items,
    this.createdDate,
    this.favourite,
  });

  CloudChecklist.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        title = snapshot.data()[checklistTitleFieldName] as String,
        items = _parseItems(snapshot.data()[checklistItemsFieldName]),
        createdDate = snapshot.data()[createdDateFieldName] as String,
        favourite = snapshot.data()[favouriteFieldName] == ""
            ? false
            : snapshot.data()[favouriteFieldName] as bool?;
}

List<ChecklistItem> _parseItems(dynamic itemsData) {
  if (itemsData == null || itemsData is! List) return [];
  return itemsData.map((item) => ChecklistItem.fromMap(item)).toList();
}

class ChecklistItem {
  final String id;
  final String text;
  final bool isChecked;

  ChecklistItem({
    required this.id,
    required this.text,
    required this.isChecked,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isChecked': isChecked,
    };
  }

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id'] as String,
      text: map['text'] as String,
      isChecked: map['isChecked'] as bool,
    );
  }

  ChecklistItem copyWith({
    String? id,
    String? text,
    bool? isChecked,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      text: text ?? this.text,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
