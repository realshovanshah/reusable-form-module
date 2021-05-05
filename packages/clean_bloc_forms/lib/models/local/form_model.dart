import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FormModel {
  FormModel(this.title, this.fileUrl, this.screenType, this.category,
      this.status, this.updatedAt, this.docId);

  String? docId = "";
  final String title;
  final String fileUrl;
  final int screenType;
  final int category;
  final bool status;
  final Timestamp createdAt = Timestamp.now();
  final Timestamp updatedAt;

  FormModel copyWith({
    String? docId,
    String? title,
    String? fileUrl,
    int? screenType,
    int? category,
    bool? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return FormModel(
      title ?? this.title,
      fileUrl ?? this.fileUrl,
      screenType ?? this.screenType,
      category ?? this.category,
      status ?? this.status,
      updatedAt ?? this.updatedAt,
      docId ?? this.docId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'fileUrl': fileUrl,
      'screenType': screenType,
      'category': category,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory FormModel.fromMap(Map<String, dynamic> map) {
    return FormModel(
        map['title'],
        map['fileUrl'],
        map['screenType'],
        map['category'],
        map['status'],
        map['updatedAt'] ?? Timestamp.now(),
        "");
  }

  String toJson() => json.encode(toMap());

  factory FormModel.fromJson(String source, String docId) =>
      FormModel.fromMap(json.decode(source));

  static FormModel fromSnapshot(DocumentSnapshot snap, String docId) {
    return FormModel(
      snap.data()?['title'],
      snap.data()?['fileUrl'],
      snap.data()?['screenType'],
      snap.data()?['category'],
      snap.data()?['status'],
      snap.data()?['updatedAt'] ?? Timestamp.now(),
      docId,
    );
  }

  @override
  String toString() {
    return 'FormModel(title: $title, fileUrl: $fileUrl, screenType: $screenType, category: $category, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormModel &&
        other.title == title &&
        other.fileUrl == fileUrl &&
        other.screenType == screenType &&
        other.category == category &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        fileUrl.hashCode ^
        screenType.hashCode ^
        category.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
