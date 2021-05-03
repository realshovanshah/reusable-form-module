import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FormModel {
  FormModel(this.venue, this.fileUrl, this.screenType, this.formType,
      this.availableStatus, this.updatedAt, this.docId);

  String? docId = "";
  final String venue;
  final String fileUrl;
  final int screenType;
  final int formType;
  final bool availableStatus;
  final Timestamp createdAt = Timestamp.now();
  final Timestamp updatedAt;

  FormModel copyWith({
    String? docId,
    String? venue,
    String? fileUrl,
    int? screenType,
    int? formType,
    bool? availableStatus,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return FormModel(
      venue ?? this.venue,
      fileUrl ?? this.fileUrl,
      screenType ?? this.screenType,
      formType ?? this.formType,
      availableStatus ?? this.availableStatus,
      updatedAt ?? this.updatedAt,
      docId ?? this.docId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'venue': venue,
      'fileUrl': fileUrl,
      'screenType': screenType,
      'formType': formType,
      'availableStatus': availableStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory FormModel.fromMap(Map<String, dynamic> map) {
    return FormModel(
        map['venue'],
        map['fileUrl'],
        map['screenType'],
        map['formType'],
        map['availableStatus'],
        map['updatedAt'] ?? Timestamp.now(),
        "");
  }

  String toJson() => json.encode(toMap());

  factory FormModel.fromJson(String source, String docId) =>
      FormModel.fromMap(json.decode(source));

  static FormModel fromSnapshot(DocumentSnapshot snap, String docId) {
    return FormModel(
      snap.data()?['venue'],
      snap.data()?['fileUrl'],
      snap.data()?['screenType'],
      snap.data()?['formType'],
      snap.data()?['availableStatus'],
      snap.data()?['updatedAt'] ?? Timestamp.now(),
      docId,
    );
  }

  @override
  String toString() {
    return 'FormModel(venue: $venue, fileUrl: $fileUrl, screenType: $screenType, formType: $formType, availableStatus: $availableStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormModel &&
        other.venue == venue &&
        other.fileUrl == fileUrl &&
        other.screenType == screenType &&
        other.formType == formType &&
        other.availableStatus == availableStatus &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return venue.hashCode ^
        fileUrl.hashCode ^
        screenType.hashCode ^
        formType.hashCode ^
        availableStatus.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
